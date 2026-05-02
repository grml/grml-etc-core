MANPAGES = grmlzshrc.5 grml-chroot.8
HTMLPAGES = grmlzshrc.html grml-chroot.html

all: $(MANPAGES) $(HTMLPAGES)

.SUFFIXES:
.SUFFIXES: .adoc .5 .8 .html

.adoc.5:
	@printf 'ASCIIDOCTOR %s\n' "$@"
	@asciidoctor -b manpage -o$@ $<

.adoc.8:
	@printf 'ASCIIDOCTOR %s\n' "$@"
	@asciidoctor -b manpage -o$@ $<

.adoc.html:
	@printf 'ASCIIDOCTOR %s\n' "$@"
	@asciidoctor -b html5 -o$@ $<

clean:
	rm -f *.5 *.8 *.html *.gz *~

.PHONY: all clean
