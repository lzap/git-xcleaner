git-xcleaner(1) -- interactive git branch removal
=================================================

## SYNOPSIS

`git xcleaner`

## DESCRIPTION

This tool helps with deleting unused topic branches using TUI (text user
interface). It also offers mechanisms for pre-selecting branches that can be
safely removed.

It is NOT recommended running garbage collection after cleanup, this can wipe
mis-deleted branches. If you want to do this, do it prior running cleaning, so
you are still able to recover after few weeks.

## WARNING

This tool deletes git branches after confirmation. There is no way back when
git garbage is collected. Double check what you are about to remove!

## ACTIONS

**Merged**

Command git branch --merged is used to find a list of branches that are marked
for deletion.

**Messages**

For each branch, tip commit message is compared against base history and if
found, the branch is marked for deletion. Whole commit message is compared and
it must fully match.

User enters base branch name (defaults to "master").

**Remote**

Delete all remote branches in remote repo which are not present locally.

User enters remote name (defaults to current username).

**Upstream**

All branches which no longer exist in origin or specific remote repository are
marked for deletion.

User enters specific remote name (defaults to current username).

**Manual**

User manually marks branches for deletion.

## ACTIVE BRANCH

Active branch is never marked for deletion.

## UNDELETING

If you mis-deleted a branch and ignored all the warnings in documentation and
on the screen, check out the homepage for instructions how to checkout your
branch back.

## RETURN VALUES

Zero on success, one on errors when manipulating with git.

## BUGS

File bugs at https://github.com/lzap/git-xcleaner/issues

## AUTHOR

Lukas Zapletal and contributors (see README.md).

## COPYRIGHT

(c) 2014 Lukas Zapletal

## SEE ALSO

git-branch(1)
