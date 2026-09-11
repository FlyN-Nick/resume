BUILD_DATE := $(shell date -u +%F)
BUILD_DIR := build
BACHELORS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-$(BUILD_DATE).pdf
MASTERS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-masters-$(BUILD_DATE).pdf
.PHONY: all bachelors masters verify pages clean
all: bachelors masters
bachelors:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-bachelors.tex
	mv $(BUILD_DIR)/resume-bachelors.pdf $(BACHELORS_PDF)
masters:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-masters.tex
	mv $(BUILD_DIR)/resume-masters.pdf $(MASTERS_PDF)
verify: all
	sh tests/verify-resume-build.sh
pages: all
	rm -rf pages-dist
	mkdir -p pages-dist
	cp pages/index.html pages-dist/index.html
	cp $(BACHELORS_PDF) pages-dist/index.pdf
	cp $(BACHELORS_PDF) $(MASTERS_PDF) pages-dist/
clean:
	latexmk -C -outdir=$(BUILD_DIR) resume-bachelors.tex resume-masters.tex
	rm -rf $(BUILD_DIR) pages-dist
