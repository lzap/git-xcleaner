git-xcleaner
============

TUI utility for interactive and fast git topic branch cleanup. Upstream site
at https://github.com/lzap/git-xcleaner

![Main menu](https://raw.githubusercontent.com/lzap/git-xcleaner/master/screenshots/01_main_menu.png)

![Selection](https://raw.githubusercontent.com/lzap/git-xcleaner/master/screenshots/02_select.png)

[![Short demonstration](http://img.youtube.com/vi/nKIRFqD02nQ/0.jpg)](https://www.youtube.com/watch?v=nKIRFqD02nQ)

Requirements
------------

* bash
* whiptail
* resize

Usage
-----

Install package or drop git-xcleaner on your path and

    $ git xcleaner

I *DO NOT* recommend running garbage collection after cleanup, this can wipe
mis-deleted branches:

    $ git gc

If you want to do this, do it *prior* running cleaning, so you are still able
to recover after few weeks.

Also, it is a good idea to prune branches prior cleaning:

    $ git fetch --prune

Installation
------------

On Fedora do `yum install git-xcleaner`, on other distros do this:

    TARGET=/usr/local/bin/git-xcleaner
    curl https://raw.githubusercontent.com/lzap/git-xcleaner/master/git-xcleaner > $TARGET
    chmod +x $TARGET

Documentation
-------------

See the [manual page](man/git-xcleaner.md).

How to undelete
---------------

If you mis-deleted a branch and ignored all the warnings in documentation and
on the screen, check out this file which contains all the deleted branch names
and commit shas:

    $ cat ~/.git-xcleaner.log
    Deleted branch feature_42 (was d82f87f).
    Deleted branch feature_21 (was 796b718).

Now you know the sha, if you haven't run git garbage collection, you can still
restore the branch with:

    $ git checkout d82f87f
    $ git checkout -b restored_branch_name

Authors
-------

* Lukáš Zapletal (`lzap_at_redhat_dot_com`)

License
-------

GNU GPL v2. See the LICENSE file.
