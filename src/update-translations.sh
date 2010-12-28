#!/bin/sh

xgettext --from-code=utf-8 \
	-x po/EXCLUDE \
	-L Glade \
	-o po/sourcery.pot \
	sourcery.glade

xgettext --from-code=utf-8 \
	-j \
	-L Python \
	-o po/sourcery.pot \
	sourcery

intltool-extract --type="gettext/ini" sourcery.desktop.in
intltool-extract --type="gettext/ini" sourcery-kde.desktop.in
sed -i '/char \*s = N_("Sourcery");/d' *.in.h
xgettext --from-code=utf-8 -j -L C -kN_ -o po/sourcery.pot sourcery.desktop.in.h
xgettext --from-code=utf-8 -j -L C -kN_ -o po/sourcery.pot sourcery-kde.desktop.in.h
rm sourcery.desktop.in.h sourcery-kde.desktop.in.h

cd po
for i in `ls *.po`; do
	msgmerge -U $i sourcery.pot
done
rm -f ./*~


