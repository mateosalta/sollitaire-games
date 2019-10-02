# Solitaire Games

A set of solitaire card games made for the Ubuntu Touch App Showdown

For more info and download links, check the wiki at: https://github.com/labsin/solitaire-games/wiki


## Licensing terms

Vectorized Playing Cards 1.3 - http://code.google.com/p/vectorized-playing-cards/
Copyright 2011 - Chris Aguilar
Licensed under LGPL 3 - www.gnu.org/copyleft/lesser.html


## Requirements

* Ubuntu SDK

* U1db - qtdeclarative5-u1db1.0


## Bugs

Because I write javascript objects to u1db, I'm experiancing bug:
https://bugs.launchpad.net/u1db-qt/+bug/1181359

This should be resolved in 13.10, but not in 13.04


## Usage

In Ubuntu sdk you can make a click package at >packaging. You will first need to remove the
/.git, /debian and /desktop because they have write protection or are unneded.
You can also issue `click build <folder-name>` to build the package.

Next you can issue:
`sudo click install --force-missing-framework --user=$USER ./*.click`
in the directory of the click package.


You can issue `qmlscene $@ solitaire-games.qml` from there to run it.

To build a deb package, copy the source in a new directory and issue
`debuild -b` from the source folder to build the package.
Afterwards you can use `sudo dpkg -i ./*.deb` in the parent directory to install it.


## TODO

* Better layout for mobile (never tested)

* Check app in confinement

* More games

