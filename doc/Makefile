MANPAGES = grmlzshrc.5
HTMLPAGES = grmlzshrc.html

all: $(MANPAGES) $(HTMLPAGES)

.SUFFIXES:
.SUFFIXES: .adoc .5 .html

.adoc.5:
	@printf 'ASCIIDOCTOR %s\n' "$@"
	@asciidoctor -b manpage -o$@ $<

.adoc.html:
	@printf 'ASCIIDOCTOR %s\n' "$@"
	@asciidoctor -b html5 -o$@ $<

clean:
	rm -f *.5 *.html *.gz *~

.PHONY: all clean
