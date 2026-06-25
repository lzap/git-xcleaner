#!/bin/bash
# Integration tests for git-xcleaner
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TMPDIR=$(mktemp -d /tmp/git-xcleaner-test.XXXXXX)
trap 'rm -rf "$TMPDIR"' EXIT

GIT_XCLEANER_LOG="$TMPDIR/git-xcleaner.log"
export GIT_XCLEANER_LOG

PASS=0
FAIL=0

# shellcheck source=git-xcleaner
source "$ROOT/git-xcleaner"

UI_INPUTBOX_RESULT=main
UI_CHECKLIST_RESULT=()
UI_CONFIRM_DELETE=1
UI_MENU_RESULT=Exit

ui_inputbox() {
  echo "$UI_INPUTBOX_RESULT"
}

ui_checklist() {
  printf '%s\n' "${UI_CHECKLIST_RESULT[@]}"
}

ui_yesno() {
  return $((UI_CONFIRM_DELETE == 1 ? 0 : 1))
}

ui_gauge() {
  cat >/dev/null
}

ui_menu() {
  echo "$UI_MENU_RESULT"
}

ui_textbox() {
  :
}

ui_infobox() {
  :
}

assert_eq() {
  local expected=$1 actual=$2 message=${3:-}
  if [[ "$expected" != "$actual" ]]; then
    echo "  FAIL: expected '$expected', got '$actual'${message:+ ($message)}"
    return 1
  fi
}

assert_branch_exists() {
  git show-ref --verify --quiet "refs/heads/$1"
}

assert_branch_missing() {
  ! git show-ref --verify --quiet "refs/heads/$1"
}

assert_state() {
  local branch=$1 expected=$2
  assert_eq "$expected" "${STATE[$branch]:-0}" "STATE[$branch]"
}

run_test() {
  local name=$1
  shift
  echo "TEST: $name"
  if (cd "$WORKDIR" && "$@"); then
    PASS=$((PASS + 1))
    echo "  OK"
  else
    FAIL=$((FAIL + 1))
  fi
}

git_commit() {
  local dir=$1 msg=$2
  git -C "$dir" -c user.email=test@example.com -c user.name='Test User' commit -m "$msg" --allow-empty
}

setup_basic_repo() {
  local dir=$1
  mkdir -p "$dir"
  git -C "$dir" init -b main
  git -C "$dir" -c user.email=test@example.com -c user.name='Test User' commit --allow-empty -m "initial"
}

setup_merged_repo() {
  local dir=$1
  setup_basic_repo "$dir"
  git -C "$dir" checkout -b feature
  git_commit "$dir" "feature work"
  git -C "$dir" checkout main
  git -C "$dir" merge --no-ff feature -m "Merge feature"
}

setup_messages_repo() {
  local dir=$1
  setup_basic_repo "$dir"
  git -C "$dir" checkout -b topic
  git_commit "$dir" "Add widget"
  git -C "$dir" checkout main
  git_commit "$dir" "Add widget"
}

setup_pruned_repo() {
  local dir=$1
  local remote="$dir/remote.git"
  local work="$dir/work"
  git init -b main "$remote" --bare
  git init -b main "$work"
  git -C "$work" remote add origin "$remote"
  git -C "$work" -c user.email=test@example.com -c user.name='Test User' commit --allow-empty -m "initial"
  git -C "$work" push -u origin main
  git -C "$work" checkout -b gone
  git -C "$work" -c user.email=test@example.com -c user.name='Test User' commit --allow-empty -m "gone branch"
  git -C "$work" push -u origin gone
  git -C "$remote" update-ref -d refs/heads/gone
  git -C "$work" fetch --prune origin
  git -C "$work" checkout main
}

test_validate_base_branch_ok() {
  validate_base_branch main
}

test_validate_base_branch_empty() {
  ! validate_base_branch ""
}

test_validate_base_branch_missing() {
  ! validate_base_branch not-a-branch
}

test_preselect_merged() {
  init_branch_state
  preselect_merged_branches main
  assert_state main 0
  assert_state feature 1
}

test_preselect_merged_skips_active() {
  git checkout feature
  init_branch_state
  preselect_merged_branches main
  assert_state feature 0
}

test_preselect_messages() {
  init_branch_state
  preselect_message_branches main
  assert_state topic 1
  assert_state main 0
}

test_preselect_messages_skips_active() {
  git checkout topic
  init_branch_state
  preselect_message_branches main
  assert_state topic 0
}

test_preselect_pruned() {
  init_branch_state
  preselect_pruned_branches
  assert_state gone 1
  assert_state main 0
}

test_action_merged_deletes() {
  UI_INPUTBOX_RESULT=main
  UI_CHECKLIST_RESULT=(feature)
  UI_CONFIRM_DELETE=1
  : >"$GIT_XCLEANER_LOG"
  action_merged
  assert_branch_missing feature
  grep -q "Deleted branch feature" "$GIT_XCLEANER_LOG"
}

test_action_merged_invalid_base() {
  UI_INPUTBOX_RESULT=not-a-branch
  ! action_merged
  assert_branch_exists feature
}

test_action_messages_deletes() {
  UI_INPUTBOX_RESULT=main
  UI_CHECKLIST_RESULT=(topic)
  UI_CONFIRM_DELETE=1
  : >"$GIT_XCLEANER_LOG"
  action_messages
  assert_branch_missing topic
  grep -q "Deleted branch topic" "$GIT_XCLEANER_LOG"
}

test_action_pruned_deletes() {
  UI_CHECKLIST_RESULT=(gone)
  UI_CONFIRM_DELETE=1
  : >"$GIT_XCLEANER_LOG"
  action_pruned
  assert_branch_missing gone
  grep -q "Deleted branch gone" "$GIT_XCLEANER_LOG"
}

test_action_manual_deletes() {
  git branch branch-b
  UI_CHECKLIST_RESULT=(branch-b)
  UI_CONFIRM_DELETE=1
  : >"$GIT_XCLEANER_LOG"
  action_manual
  assert_branch_missing branch-b
  grep -q "Deleted branch branch-b" "$GIT_XCLEANER_LOG"
}

test_delete_no_confirm() {
  git branch keep-me
  UI_CHECKLIST_RESULT=(keep-me)
  UI_CONFIRM_DELETE=0
  action_manual
  assert_branch_exists keep-me
}

run_fixture() {
  local fixture=$1
  shift
  local case_dir="$TMPDIR/$fixture"
  rm -rf "$case_dir"
  "$fixture" "$case_dir"
  WORKDIR="$case_dir/work"
  [[ -d "$WORKDIR" ]] || WORKDIR="$case_dir"
  for test_fn; do
    UI_INPUTBOX_RESULT=main
    UI_CHECKLIST_RESULT=()
    UI_CONFIRM_DELETE=1
    if git -C "$WORKDIR" show-ref --verify --quiet refs/heads/main 2>/dev/null; then
      git -C "$WORKDIR" checkout -f main >/dev/null 2>&1
    fi
    run_test "$fixture/$test_fn" "$test_fn"
  done
}

run_fixture setup_basic_repo \
  test_validate_base_branch_ok \
  test_validate_base_branch_empty \
  test_validate_base_branch_missing

run_fixture setup_merged_repo \
  test_preselect_merged \
  test_preselect_merged_skips_active \
  test_action_merged_invalid_base \
  test_action_merged_deletes

run_fixture setup_messages_repo \
  test_preselect_messages \
  test_preselect_messages_skips_active \
  test_action_messages_deletes

run_fixture setup_pruned_repo \
  test_preselect_pruned \
  test_action_pruned_deletes

run_fixture setup_basic_repo \
  test_action_manual_deletes \
  test_delete_no_confirm

echo ""
echo "PASS=$PASS FAIL=$FAIL"
[[ $FAIL -eq 0 ]]
