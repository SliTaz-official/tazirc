# Makefile for SliTaz IRC.
#

PREFIX?=/usr
DESTDIR?=
LINGUAS?=fr

VERSION=1.0

all: msgfmt

# i18n.

pot:
	xgettext -o po/tazirc.pot -L Shell --package-name="TazIRC" \
		--package-version="$(VERSION)" ./tazirc ./tazirc-lb

msgmerge:
	@for l in $(LINGUAS); do \
		if [ -f "po/$$l.po" ]; then \
			echo -n "Updating $$l po file."; \
			msgmerge -U po/$$l.po po/tazirc.pot ; \
		fi;\
	done;

msgfmt:
	@for l in $(LINGUAS); do \
		if [ -f "po/$$l.po" ]; then \
			echo "Compiling TazIRC $$l mo file..."; \
			mkdir -p po/mo/$$l/LC_MESSAGES; \
			msgfmt -o po/mo/$$l/LC_MESSAGES/tazirc.mo po/$$l.po ; \
		fi;\
	done;

# Install

install:
	install -m 0777 -d $(DESTDIR)$(PREFIX)/bin
	#install -m 0777 -d $(DESTDIR)$(PREFIX)/share/applications
	install -m 0777 -d $(DESTDIR)$(PREFIX)/share/locale
	install -m 0755 tazirc $(DESTDIR)$(PREFIX)/bin
	install -m 0755 tazirc-lb $(DESTDIR)$(PREFIX)/bin
	#install -m 0644 data/*.desktop \
		#$(DESTDIR)$(PREFIX)/share/applications
	cp -a po/mo/* $(DESTDIR)$(PREFIX)/share/locale

# Uninstall

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/tazirc*
	#rm -f $(DESTDIR)$(PREFIX)/share/applications/tazirc*
	rm -rf $(DESTDIR)$(PREFIX)/share/locale/*/LC_MESSAGES/tazirc.mo

# Clean

clean:
	rm -rf po/*~
	rm -rf po/mo
