#author: Mareike Picklum
#mail: mareikep@cs.uni-bremen.de

PROJECT=crc-2025
PROPOSAL=$(PROJECT)
COVER=$(PROJECT)-cover

TYPSTC  = ./typst compile
TYPSTW	= ./typst watch

# Colors
RED   = \033[0;31m
CYAN  = \033[0;36m
NC    = \033[0m
echoPROJECT = @echo -e "$(CYAN) <$(PROJECT)>$(RED)"

.PHONY:  all watch cover prepare


all: prepare compile cover

watch:
	@$(echoPROJECT) "* watching proposal * $(NC)"
	@$(TYPSTW) $(PROPOSAL).typ

compile:
	@$(echoPROJECT) "* single compiling proposal * $(NC)"
	@$(TYPSTC) $(PROPOSAL).typ
	@$(echoPROJECT) "* proposal compiled * $(NC)"
 
cover:
	$(echoPROJECT) "* compiling double cover page * $(NC)"
	@$(TYPSTC) --ppi 600 --format svg $(COVER).typ
	@$(TYPSTC) --ppi 600 --format png $(COVER).typ
	@$(TYPSTC) --ppi 600 --format pdf $(COVER).typ
	$(echoPROJECT) "* double cover page compiled as $(COVER).svg, $(COVER).png and $(COVER).pdf files * $(NC)"

prepare:
	$(echoPROJECT) "* preparing document setup * $(NC)"
	@time python read-metadata.py
	$(echoPROJECT) "* preparation complete. * $(NC)"

