TEX=pdflatex
#BIB=bibtex
FILE=sweet-switches_slides

#all: $(FILE).tex $(FILE).bib
all: $(FILE).tex
	$(TEX) $(FILE).tex
	$(TEX) $(FILE).tex

view: all
	zathura $(FILE).pdf

clean:
	rm -rf $(FILE).aux $(FILE).bbl $(FILE).blg $(FILE).log $(FILE).toc $(FILE).out $(FILE).nav $(FILE).snm

clean_all: clean
	rm -rf $(FILE).pdf
