TEX=pdflatex
FILE=gdd_IceCreamFactory
OUTPUT_DIR=output

all: $(FILE).tex
    # Creates ouput directory if it doesn't exist.
	mkdir -p $(OUTPUT_DIR)
	$(TEX) -output-directory $(OUTPUT_DIR) $(FILE).tex
	$(TEX) -output-directory $(OUTPUT_DIR) $(FILE).tex

clean:
	rm -rf $(OUTPUT_DIR)/$(FILE).aux  $(OUTPUT_DIR)/$(FILE).log $(OUTPUT_DIR)/$(FILE).toc $(OUTPUT_DIR)/$(FILE).out

clean_all: clean
	rm -rf $(OUTPUT_DIR)/$(FILE).pdf
