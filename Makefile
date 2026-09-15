BUILD_DATE := $(shell date -u +%F)
BUILD_DIR := build

AI_SECURITY_BACHELORS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-$(BUILD_DATE).pdf
AI_SECURITY_MASTERS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-masters-$(BUILD_DATE).pdf
AI_ML_RESEARCH_BACHELORS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-ai-ml-research-$(BUILD_DATE).pdf
AI_ML_RESEARCH_MASTERS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-ai-ml-research-masters-$(BUILD_DATE).pdf
SECURITY_ENGINEERING_BACHELORS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-security-engineering-$(BUILD_DATE).pdf
SECURITY_ENGINEERING_MASTERS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-security-engineering-masters-$(BUILD_DATE).pdf
SOFTWARE_ML_ENGINEERING_BACHELORS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-software-ml-engineering-$(BUILD_DATE).pdf
SOFTWARE_ML_ENGINEERING_MASTERS_PDF := $(BUILD_DIR)/nicholas-assaderaghi-resume-software-ml-engineering-masters-$(BUILD_DATE).pdf

.PHONY: all editions bachelors masters ai-ml-research-bachelors ai-ml-research-masters security-engineering-bachelors security-engineering-masters software-ml-engineering-bachelors software-ml-engineering-masters verify pages clean

all: editions

editions: bachelors masters ai-ml-research-bachelors ai-ml-research-masters security-engineering-bachelors security-engineering-masters software-ml-engineering-bachelors software-ml-engineering-masters

bachelors:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-bachelors.tex
	mv $(BUILD_DIR)/resume-bachelors.pdf $(AI_SECURITY_BACHELORS_PDF)

masters:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-masters.tex
	mv $(BUILD_DIR)/resume-masters.pdf $(AI_SECURITY_MASTERS_PDF)

ai-ml-research-bachelors:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-ai-ml-research-bachelors.tex
	mv $(BUILD_DIR)/resume-ai-ml-research-bachelors.pdf $(AI_ML_RESEARCH_BACHELORS_PDF)

ai-ml-research-masters:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-ai-ml-research-masters.tex
	mv $(BUILD_DIR)/resume-ai-ml-research-masters.pdf $(AI_ML_RESEARCH_MASTERS_PDF)

security-engineering-bachelors:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-security-engineering-bachelors.tex
	mv $(BUILD_DIR)/resume-security-engineering-bachelors.pdf $(SECURITY_ENGINEERING_BACHELORS_PDF)

security-engineering-masters:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-security-engineering-masters.tex
	mv $(BUILD_DIR)/resume-security-engineering-masters.pdf $(SECURITY_ENGINEERING_MASTERS_PDF)

software-ml-engineering-bachelors:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-software-ml-engineering-bachelors.tex
	mv $(BUILD_DIR)/resume-software-ml-engineering-bachelors.pdf $(SOFTWARE_ML_ENGINEERING_BACHELORS_PDF)

software-ml-engineering-masters:
	@mkdir -p $(BUILD_DIR)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) resume-software-ml-engineering-masters.tex
	mv $(BUILD_DIR)/resume-software-ml-engineering-masters.pdf $(SOFTWARE_ML_ENGINEERING_MASTERS_PDF)

verify: editions
	BUILD_DATE=$(BUILD_DATE) sh tests/verify-resume-build.sh

# GitHub Pages intentionally publishes only the default AI-security résumé.
pages: bachelors masters
	rm -rf pages-dist
	mkdir -p pages-dist
	cp pages/index.html pages-dist/index.html
	cp $(AI_SECURITY_BACHELORS_PDF) pages-dist/index.pdf
	cp $(AI_SECURITY_BACHELORS_PDF) $(AI_SECURITY_MASTERS_PDF) pages-dist/

clean:
	rm -rf $(BUILD_DIR) pages-dist
