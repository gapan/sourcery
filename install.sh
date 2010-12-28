#!/bin/sh

install -d -m 755 $DESTDIR/usr/sbin
install -d -m 755 $DESTDIR/usr/share/applications
install -d -m 755 $DESTDIR/usr/share/sourcery
install -m 755 src/sourcery $DESTDIR/usr/sbin/
install -m 644 src/sourcery.glade $DESTDIR/usr/share/sourcery/
install -m 644 sourcery.desktop $DESTDIR/usr/share/applications/
install -m 644 sourcery-kde.desktop $DESTDIR/usr/share/applications/

# install the log dir
install -d -m 755 $DESTDIR/var/log/sourcery

# Install icons
install -d -m 755 $DESTDIR/usr/share/icons/hicolor/scalable/apps/
install -m 644 icons/sourcery.svg $DESTDIR/usr/share/icons/hicolor/scalable/apps/

for i in 48 32 24 22 16; do
	install -d -m 755 \
	$DESTDIR/usr/share/icons/hicolor/${i}x${i}/apps/ \
	2> /dev/null
	install -m 644 icons/sourcery-$i.png \
	$DESTDIR/usr/share/icons/hicolor/${i}x${i}/apps/sourcery.png
done

for i in `ls po/*.po|sed "s/po\/\(.*\)\.po/\1/"`; do
	install -d -m 755 $DESTDIR/usr/share/locale/$i/LC_MESSAGES
	install -m 644 po/$i.mo $DESTDIR/usr/share/locale/$i/LC_MESSAGES/sourcery.mo
done
