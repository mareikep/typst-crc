# author: Mareike Picklum
# mail: mareikep@cs.uni-bremen.de

PROJECT = crc-2025
PROPOSAL = $(PROJECT)
COVER = $(PROJECT)-cover

# Colors
RED     = \033[1;31m
GREEN   = \033[1;32m
YELLOW  = \033[1;33m
BLUE    = \033[1;34m
MAGENTA = \033[1;35m
CYAN    = \033[0;36m
NC      = \033[0m

UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
	OS_MSG  := "* selected Linux executable *"
	TYPSTC  = ./typst-linux compile
	TYPSTW	= ./typst-linux watch
else ifeq ($(UNAME), Darwin)
	OS_MSG  := "* selected Darwin executable *"
	TYPSTC  = ./typst-darwin compile
	TYPSTW	= ./typst-darwin watch
else ifneq ($(filter MINGW%,$(UNAME)),)
	OS_MSG  := "* selected Windows (MINGW) executable *"
	TYPSTC  = ./typst.exe compile
	TYPSTW	= ./typst.exe watch
else ifneq ($(filter MSYS%,$(UNAME)),)
	OS_MSG  := "* selected Windows (MSYS) executable *"
	TYPSTC  = ./typst.exe compile
	TYPSTW	= ./typst.exe watch
else
	OS_MSG  := "* selected default (Linux) executable *"
	TYPSTC  = ./typst-linux compile
	TYPSTW	= ./typst-linux watch
endif

.PHONY: all watch cover prepare info

all: info prepare compile cover

watch:
	@echo -e "$(CYAN)<$(PROJECT)>$(MAGENTA) * watching proposal... * $(NC)"
	@$(TYPSTW) $(PROPOSAL).typ

compile:
	@echo -e "$(CYAN)<$(PROJECT)>$(RED) * single compiling proposal... * $(NC)"
	@$(TYPSTC) $(PROPOSAL).typ
	@echo -e "$(CYAN)<$(PROJECT)>$(RED) * proposal compiled *$(NC)"

cover:
	@echo -e "$(CYAN)<$(PROJECT)>$(BLUE) * compiling double cover page... *$(NC)"
	@$(TYPSTC) --ppi 600 --format svg $(COVER).typ
	@$(TYPSTC) --ppi 600 --format png $(COVER).typ
	@$(TYPSTC) --ppi 600 --format pdf $(COVER).typ
	@echo -e "$(CYAN)<$(PROJECT)>$(BLUE) * double cover page compiled to output files $(COVER).svg, $(COVER).png and $(COVER).pdf *$(NC)"

prepare:
	@echo -e "$(CYAN)<$(PROJECT)>$(YELLOW) * preparing document setup... *$(NC)"
	@time python read-metadata.py
	@echo -e "$(CYAN)<$(PROJECT)>$(YELLOW) * preparation complete *$(NC)"

info:
	@echo -e "$(CYAN)<$(PROJECT)>$(GREEN) $(OS_MSG) $(NC)"
