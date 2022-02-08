MANPAGES = grmlzshrc.5
HTMLPAGES = grmlzshrc.html

all: $(MANPAGES) $(HTMLPAGES)

.SUFFIXES:
.SUFFIXES: .t2t .5 .html

.t2t.5:
	@printf 'TXT2TAGS %s\n' "$@"
	@txt2tags --quiet --target man -o$@.pre $<
	@sed -e '/^$$/d' -e 's/^\\e$$//' < $@.pre > $@.tmp
	@rm $@.pre
	@mv $@.tmp $@

.t2t.html:
	@printf 'TXT2TAGS %s\n' "$@"
	@txt2tags --quiet --target html --style t2t-modern.css -o$@.pre $<
	@sed -e '/^$$/d' -e 's/^\\$$//' < $@.pre > $@.tmp
	@rm $@.pre
	@mv $@.tmp $@

clean:
	rm -f *.5 *.html *.gz *.pre *.tmp *~

online: all
	scp grmlzshrc.html t2t-modern.css grml:/var/www/grml/zsh/

.PHONY: all clean online
