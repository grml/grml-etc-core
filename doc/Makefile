MANPAGES = grmlzshrc.5
HTMLPAGES = grmlzshrc.html

all: $(MANPAGES) $(HTMLPAGES)

.SUFFIXES:
.SUFFIXES: .t2t .5 .html

.t2t.5:
	@printf 'TXT2TAGS %s > %s\n' "$<" "$@"
	@txt2tags --target man -o- $< | sed -e '/^$$/d' -e 's/^\\e$$//' > $@

.t2t.html:
	@printf 'TXT2TAGS %s > %s\n' "$<" "$@"
	@txt2tags --target html --style t2t-modern.css -o- $< \
| sed -e '/^$$/d' -e 's/^\\$$//' > $@

clean:
	rm -f *.5 *.html *.gz *~

online: all
	scp grmlzshrc.html t2t-modern.css grml:/var/www/grml/zsh/

.PHONY: all clean
