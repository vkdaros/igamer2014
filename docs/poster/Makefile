TEX=pdflatex
FILE=poster

all: $(FILE)

$(FILE): $(FILE).tex
	#$(TEX) --enable-write18 $<
	$(TEX) $<

clean:
	rm -rf $(FILE).aux $(FILE).bbl $(FILE).blg $(FILE).log $(FILE).toc $(FILE).out

clean_all: clean
	rm -rf $(FILE).pdf
