# Detect OS
PROJECT  = crc-2025
PROPOSAL = $(PROJECT)
COVER    = $(PROJECT)-cover

# Colors using escape character
ESC := $(shell printf '\033')
COLOR_RESET  := $(ESC)[0m
COLOR_RED     = \033[1;31m
COLOR_GREEN   = \033[1;32m
COLOR_YELLOW  = \033[1;33m
COLOR_BLUE    = \033[1;34m
COLOR_MAGENTA = \033[1;35m
COLOR_CYAN    = \033[0;36m
COLOR_WHITE   = \033[1;37m

UNAME_S := $(shell uname -s)

ifeq ($(OS),Windows_NT)
    OS_TYPE := Windows
    FALLBACK_TYPST := ./typst.exe
else ifeq ($(UNAME_S),Darwin)
    OS_TYPE := macOS
    FALLBACK_TYPST := ./typst-darwin
else ifeq ($(UNAME_S),Linux)
    OS_TYPE := Linux
    FALLBACK_TYPST := ./typst-linux
else
    OS_TYPE := Unknown
    FALLBACK_TYPST := typst
endif

# Check if global `typst` exists
GLOBAL_TYPST := $(shell command -v typst 2>/dev/null || echo "")
  
# Select executable and set message accordingly
ifeq ($(GLOBAL_TYPST),)
    TYPST := $(FALLBACK_TYPST)
    INFO_MSG := * using executable for $(COLOR_WHITE)$(OS_TYPE)$(COLOR_RESET): $(TYPST)$(COLOR_GREEN) *
else
    TYPST := typst
    # Try to get version; fallback to empty string if it fails
    TYPST_VERSION := $(shell typst --version 2>/dev/null || echo "unknown version")
    INFO_MSG := * using installed typst version $(COLOR_RESET) $(TYPST_VERSION)$(COLOR_GREEN) *
endif

# Default python command
PYTHON ?= python

ifeq ($(OS_TYPE),Windows)
  MSYS := $(shell uname -o 2>/dev/null)
  ifneq (,$(findstring Msys,$(MSYS)))
    # Running inside MSYS2 on Windows

    # Use powershell to get Windows user profile path
    WIN_USER_HOME := $(shell powershell.exe -NoProfile -Command "[Environment]::GetFolderPath('UserProfile')" 2>/dev/null | tr -d '\r' | tr '\\' '/')

    # Construct path to global Python (adjust version as needed)
    WIN_PY := $(WIN_USER_HOME)/AppData/Local/Programs/Python/Python313/python.exe

    # Use WIN_PY if it exists
    ifneq ("$(wildcard $(WIN_PY))","")
      PYTHON := $(WIN_PY)
    endif
  endif
endif

.PHONY: all watch cover prepare info compile

all: info prepare compile cover

info:
	@printf "$(COLOR_CYAN)<$(PROJECT)>$(COLOR_GREEN) $(INFO_MSG)$(COLOR_RESET)\n"

watch:
	@printf "$(COLOR_CYAN)<$(PROJECT)>$(COLOR_MAGENTA) * watching proposal... *$(COLOR_RESET)\n"
	@$(TYPST) watch $(PROPOSAL).typ

compile:
	@printf "$(COLOR_CYAN)<$(PROJECT)>$(COLOR_RED) * single compiling proposal... *$(COLOR_RESET)\n"
	@$(TYPST) compile $(PROPOSAL).typ
	@printf "$(COLOR_CYAN)<$(PROJECT)>$(COLOR_RED) * proposal compiled *$(COLOR_RESET)\n"

cover:
	@printf "$(COLOR_CYAN)<$(PROJECT)>$(COLOR_BLUE) * compiling double cover page... *$(COLOR_RESET)\n"
	@$(TYPST) compile --ppi 600 --format svg $(COVER).typ
	@$(TYPST) compile --ppi 600 --format png $(COVER).typ
	@$(TYPST) compile --ppi 600 --format pdf $(COVER).typ
	@printf "$(COLOR_CYAN)<$(PROJECT)>$(COLOR_BLUE) * double cover page compiled to output files $(COLOR_RESET)$(COVER).svg, $(COVER).png and $(COVER).pdf $(COLOR_BLUE)*$(COLOR_RESET)\n"

prepare:
	@printf "$(COLOR_CYAN)<$(PROJECT)>$(COLOR_YELLOW) * preparing document setup... *$(COLOR_RESET)\n"
	@printf "$(COLOR_CYAN)<$(PROJECT)>$(COLOR_YELLOW) * using python interpreter: $(COLOR_RESET)$(PYTHON)$(COLOR_YELLOW) *$(COLOR_RESET)\n"
	@time $(PYTHON) metadata/read-metadata.py
	@printf "$(COLOR_CYAN)<$(PROJECT)>$(COLOR_YELLOW) * preparation complete *$(COLOR_RESET)\n"

debug-home:
	@echo "HOME is: $(shell echo $$HOME)"