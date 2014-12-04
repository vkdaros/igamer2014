TEX=pdflatex
BIB=bibtex
FILE=poster

all: $(FILE)

$(FILE): $(FILE).tex $(FILE).bib
	$(TEX) --enable-write18 $<
#	$(BIB) $@
#	$(TEX) $<
	$(TEX) $<

clean:
	rm -rf $(FILE).aux $(FILE).bbl $(FILE).blg $(FILE).log $(FILE).toc $(FILE).out

clean_all: clean
	rm -rf $(FILE).pdf
