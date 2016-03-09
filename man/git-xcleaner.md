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
