### Standard PDF Viewers
# Defines a set of standard PDF viewer tools to use when displaying the result
# with the display target. Currently chosen are defaults which should work on
# most linux systems with GNOME installed and on all OSX systems.

UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
PDFVIEWER = evince
OPEN=$(PDFVIEWER)
endif

ifeq ($(UNAME), Darwin)
PDFVIEWER = Preview
OPEN=open -a $(PDFVIEWER)
endif

INPUT_FILE=main
OUTPUT_DIR=dist

all:
	# Clean previous builds
	$(MAKE) clean

	# Close the PDF Viewer (if it is open)
	@-killall $(PDFVIEWER)

	# Usual process to generate the PDF
	pdflatex -halt-on-error $(INPUT_FILE)
	bibtex $(INPUT_FILE)
	pdflatex -halt-on-error  $(INPUT_FILE)
	pdflatex -halt-on-error  $(INPUT_FILE)

	# Remove all generated files (and keep only the PDF)
	$(MAKE) clean

	# Create the dist folder and move the generated file into it
	@-mkdir $(OUTPUT_DIR)
	mv $(INPUT_FILE).pdf $(OUTPUT_DIR)

	# HABEMUS PDF
	$(OPEN) $(OUTPUT_DIR)/$(INPUT_FILE).pdf

clean:
	@-rm *.aux *.bbl *.dvi *.blg *.lof *.lot *.toc *.log *.out
	@-rm -rf dist
