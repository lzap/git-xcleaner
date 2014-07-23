git-xcleaner(1) -- interactive git branch deletion
==================================================

## SYNOPSIS

`git xcleaner`

## DESCRIPTION

This tool helps with deleting unused topic branches using TUI (text user
interface). It also offers mechanisms for pre-selecting branches that can be
safely removed.

## WARNING

This tool deletes git branches after confirmation. There is no way back when
git garbage is collected. Double check what you are about to remove!

## RETURN VALUES

Zero on success, one on errors when manipulating with git.

## BUGS

File bugs at https://github.com/lzap/git-xcleaner/issues

## AUTHOR

Lukáš Zapletal and contributors (see README.md).

## COPYRIGHT

(c) 2014 Lukáš Zapletal

## SEE ALSO

git-branch(1)
