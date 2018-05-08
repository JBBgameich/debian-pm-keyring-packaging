prefix = /usr
datadir = $(prefix)/share
sysconfdir = /etc
keyringdir = $(datadir)/keyrings
apttrusteddir = $(sysconfdir)/apt/trusted.gpg.d

GPG = gpg
INSTALL = install
INSTALL_DATA = $(INSTALL) -s -m644

KEYS = *.asc
KEYRING = debian-pm-archive-keyring.gpg

$(KEYRING): $(KEYS)
	mkdir -p -m700 gnupg
	keys='$^'; \
	for key in $$keys; do \
	$(GPG) --homedir gnupg --import $$key || exit 1; \
	done
	$(GPG) --homedir gnupg --export > $@

install: $(KEYRING)
	mkdir -p $(DESTDIR)$(keyringdir) $(DESTDIR)$(apttrusteddir)
	$(INSTALL_DATA) $(KEYRING) $(DESTDIR)$(keyringdir)
	$(INSTALL_DATA) $(KEYRING) $(DESTDIR)$(apttrusteddir)

clean:
	rm -f $(KEYRING)
	rm -rf gnupg
