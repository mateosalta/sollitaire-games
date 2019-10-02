#!/bin/bash
FROMDIR="$(pwd)"
TRANSDIR="${FROMDIR}/../trans"
BUILDDIR="${FROMDIR}_click"
NAME="solitaire-games"
rm -rf $BUILDDIR
cp -r $FROMDIR $BUILDDIR
cp -r ${TRANSDIR}/po ${BUILDDIR}
echo "Entering ${BUILDDIR}"
cd $BUILDDIR
rm -rf .git* .bzr* debian desktop ${NAME}.qmlp* \
${NAME}128.png ${NAME}16.png ${NAME}32.png \
${NAME}64.png make_click.sh README.md LICENSE
cd po
echo "Generating mo files"
./generate_mo.sh
cd ..
rm -r po
cd ..
echo "Build click package in `pwd`"
click build $BUILDDIR
cd $FROMDIR

