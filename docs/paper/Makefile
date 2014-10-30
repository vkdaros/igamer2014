TEX=pdflatex
BIB=bibtex
FILE=igamer_paper
OUTPUT_DIR=output
TEXMFOUTPUT=$(OUTPUT_DIR)

# Definition of basic commands according to the operating system.
$(info Target platform: $(OS))
ifeq ($(OS),Windows_NT)
	RM=del /s/q
	MD=mkdir
	SEP=\\
	CP=copy
else
	RM=rm -rf
	MD=mkdir -p
	SEP=/
	CP=cp
endif

all: $(FILE).tex
ifeq ($(OS),Windows_NT)
	if not exist $(OUTPUT_DIR) $(MD) $(OUTPUT_DIR)
else
	$(MD) $(OUTPUT_DIR)
endif
	$(TEX) -output-directory $(OUTPUT_DIR) $(FILE).tex
	$(BIB) $(OUTPUT_DIR)$(SEP)$(FILE)
	$(TEX) -output-directory $(OUTPUT_DIR) $(FILE).tex
	$(TEX) -output-directory $(OUTPUT_DIR) $(FILE).tex

clean:
	$(RM) $(OUTPUT_DIR)$(SEP)$(FILE).aux  $(OUTPUT_DIR)$(SEP)$(FILE).log\
    $(OUTPUT_DIR)$(SEP)$(FILE).toc $(OUTPUT_DIR)$(SEP)$(FILE).out\
    $(OUTPUT_DIR)$(SEP)$(FILE).blg $(OUTPUT_DIR)$(SEP)$(FILE).bbl

clean_all: clean
	$(RM) $(OUTPUT_DIR)$(SEP)$(FILE).pdf
