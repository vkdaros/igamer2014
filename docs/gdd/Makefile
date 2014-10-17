TEX=pdflatex
FILE=gdd_IceCreamFactory
OUTPUT_DIR=output

# Definition of basic commands according to the operating system.
$(info Target platform: $(OS))
ifeq ($(OS),Windows_NT)
	RM=del /s/q
	MD=mkdir
	SEP=\\
else
	RM=rm -rf
	MD=mkdir -p
	SEP=/
endif

all: $(FILE).tex
ifeq ($(OS),Windows_NT)
	if not exist $(OUTPUT_DIR) $(MD) $(OUTPUT_DIR)
else
	$(MD) $(OUTPUT_DIR)
endif
	$(TEX) -output-directory $(OUTPUT_DIR) $(FILE).tex
	$(TEX) -output-directory $(OUTPUT_DIR) $(FILE).tex

clean:
	$(RM) $(OUTPUT_DIR)$(SEP)$(FILE).aux  $(OUTPUT_DIR)$(SEP)$(FILE).log\
    $(OUTPUT_DIR)$(SEP)$(FILE).toc $(OUTPUT_DIR)$(SEP)$(FILE).out

clean_all: clean
	$(RM) $(OUTPUT_DIR)$(SEP)$(FILE).pdf
