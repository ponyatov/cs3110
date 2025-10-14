.PHONY : install update ref gz
install: $(WS)_install doc gz ref $(OPAM)
	$(MAKE) update
update : $(WS)_update
	opam install -y . --deps-only && dune build
ref    : $(RF)
gz     : $(GZ)

Debian_install:
# sudo dpkg --add-architecture i386
Debian_update:
	sudo apt update
	sudo apt install -uy `cat apt.$(WS)` $(APT)

Msys_install: doc ref gz
	pacman -Suy
Msys_update:
	pacman -S $(shell cat apt.$(WS) | tr '\n' ' ') $(MSYS)
