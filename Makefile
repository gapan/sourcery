PREFIX ?= /usr/local
DESTDIR ?= /
PACKAGE_LOCALE_DIR ?= /usr/share/locale

.PHONY: all
all: mo desktop

.PHONY: mo
mo:
	for i in `ls po/*.po`; do \
		msgfmt $$i -o `echo $$i | sed "s/\.po//"`.mo; \
	done

.PHONY: desktop
desktop:
	intltool-merge po/ -d -u \
		sourcery.desktop.in sourcery.desktop
	intltool-merge po/ -d -u \
		sourcery-kde.desktop.in sourcery-kde.desktop

.PHONY: updatepo
updatepo:
	for i in `ls po/*.po`; do \
		msgmerge -UNs $$i po/sourcery.pot; \
	done
	rm -f po/*~

.PHONY: pot
pot:
	xgettext --from-code=utf-8 \
		-x po/EXCLUDE \
		-L Glade \
		-o po/sourcery.pot \
		src/sourcery.ui
	xgettext --from-code=utf-8 \
		-j \
		-L Python \
		-o po/sourcery.pot \
		src/sourcery
	intltool-extract --type="gettext/ini" \
		sourcery.desktop.in
	intltool-extract --type="gettext/ini" \
		sourcery-kde.desktop.in
	sed -i '/char \*s = N_("Sourcery");/d' *.in.h
	xgettext --from-code=utf-8 -j -L C -kN_ \
		-o po/sourcery.pot sourcery.desktop.in.h
	xgettext --from-code=utf-8 -j -L C -kN_ \
		-o po/sourcery.pot sourcery-kde.desktop.in.h
	rm -f sourcery.desktop.in.h sourcery-kde.desktop.in.h

.PHONY: clean
clean:
	rm -f po/*.mo
	rm -f po/*.po~
	rm -f sourcery.desktop sourcery-kde.desktop

.PHONY: install
install: install-icons install-mo
	install -d -m 755 $(DESTDIR)/usr/sbin
	install -d -m 755 $(DESTDIR)/usr/share/applications
	install -d -m 755 $(DESTDIR)/usr/share/sourcery
	install -d -m 755 $(DESTDIR)/etc
	install -m 755 src/sourcery $(DESTDIR)/usr/sbin/
	install -m 644 src/sourcery.ui $(DESTDIR)/usr/share/sourcery/
	install -m 644 sourcery.desktop $(DESTDIR)/usr/share/applications/
	install -m 644 sourcery-kde.desktop $(DESTDIR)/usr/share/applications/
	install -m 644 sourcery.conf $(DESTDIR)/etc/
	install -d -m 755 $(DESTDIR)/var/log/sourcery

.PHONY: install-icons
install-icons:
	install -d -m 755 $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/
	install -m 644 icons/sourcery.svg \
		$(DESTDIR)/usr/share/icons/hicolor/scalable/apps/
	install -d -m 755 $(DESTDIR)/usr/share/sourcery/pixmaps
	install -m 644 pixmaps/* \
		$(DESTDIR)/usr/share/sourcery/pixmaps/
	for i in 48 32 24 22 16; do \
		install -d -m 755 \
		$(DESTDIR)/usr/share/icons/hicolor/$${i}x$${i}/apps/ \
		2> /dev/null; \
		install -m 644 icons/sourcery-$$i.png \
		$(DESTDIR)/usr/share/icons/hicolor/$${i}x$${i}/apps/sourcery.png; \
	done

.PHONY: install-mo
install-mo:
	for i in `ls po/*.po|sed "s/po\/\(.*\)\.po/\1/"`; do \
		install -d -m 755 $(DESTDIR)/usr/share/locale/$$i/LC_MESSAGES; \
		install -m 644 po/$$i.mo $(DESTDIR)/usr/share/locale/$$i/LC_MESSAGES/sourcery.mo; \
	done

.PHONY: tx-pull
tx-pull:
	tx pull -a
	@for i in `ls po/*.po`; do \
		msgfmt --statistics $$i 2>&1 | grep "^0 translated" > /dev/null \
			&& rm $$i || true; \
	done
	@rm -f messages.mo

.PHONY: tx-pull-f
tx-pull-f:
	tx pull -a -f
	@for i in `ls po/*.po`; do \
		msgfmt --statistics $$i 2>&1 | grep "^0 translated" > /dev/null \
			&& rm $$i || true; \
	done
	@rm -f messages.mo

.PHONY: stat
stat:
	@for i in `ls po/*.po`; do \
		echo "Statistics for $$i:"; \
		msgfmt --statistics $$i 2>&1; \
		echo; \
	done
	@rm -f messages.mo

