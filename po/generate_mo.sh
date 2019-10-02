#!/bin/sh
#
# Copyright 2012 Canonical Ltd.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

BUILDDIR=..
DOMAIN=com.ubuntu.developer.labsin.solitaire-games
TARGET=./

for f in `find $TARGET -type f -name "*.po"`
    do
        LANG=${f%.*}
        LANG=${LANG#$TARGET}
        echo $LANG
        EXTENSION=${f#*.}
        mkdir -p $BUILDDIR/share/locale/$LANG/LC_MESSAGES
        msgfmt $f -o $BUILDDIR/share/locale/$LANG/LC_MESSAGES/$DOMAIN.mo
        itstool -m $BUILDDIR/share/locale/$LANG/LC_MESSAGES/$DOMAIN.mo -o $BUILDDIR/data/games_$LANG.xml \
          $BUILDDIR/data/games.xml
    done
