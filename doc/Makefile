
%.html : %.txt ;
	asciidoc -b xhtml11 $^

%.gz : %.txt ;
	a2x -f manpage $^ 2>&1 |grep -v '^Note: ' >&2
	gzip -f --best $(patsubst %.txt,%, $^)

MANPAGES = $(patsubst %.txt,%,$(wildcard *.txt))

all: doc

doc: doc_man doc_html
doc_html: $(addsuffix .html, $(MANPAGES))
doc_man: $(addsuffix .gz, $(MANPAGES))

clean:
	@for i in $(MANPAGES); do \
		rm -f $$i.html $$i.xml $$i.gz; done

