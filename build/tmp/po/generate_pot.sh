cd ..
find ./ -name \*.qml -exec xgettext -o po/solitaire-games_qml.pot --qt --c++ --add-comments=TRANSLATORS --keyword=tr {} +
itstool -o po/solitaire-games_xml.pot data/games.xml
cd po
msgcat -o solitaire-games_gettext.pot solitaire-games_xml.pot \
solitaire-games_qml.pot --lang=en --strict
msgmerge -N solitaire-games.pot solitaire-games_gettext.pot > solitaire-games_new.pot
mv solitaire-games_new.pot solitaire-games.pot
rm solitaire-games_xml.pot solitaire-games_qml.pot solitaire-games_gettext.pot
