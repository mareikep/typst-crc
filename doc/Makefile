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

# Detect OS
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

compile-raw:
	# Usage: make compile-raw SRC=_src/pages/foo.typ TGT=foo.html
	@$(TYPST) compile --features html --format html --root . $(SRC) $(TGT)

watch-raw:
	# Usage: make watch-raw SRC=_src/pages/foo.typ TGT=foo.html
	@$(TYPST) watch --features html --format html --root . --no-serve $(SRC) $(TGT)

# ----------------
# Compile/watch single file
# ----------------
compile-file:
	# Usage: make compile-file BASE=foo
	$(MAKE) compile-raw SRC=_src/pages/$(BASE).typ TGT=$(BASE).html

watch-file:
	# Usage: make watch-file BASE=foo
	$(MAKE) watch-raw SRC=_src/pages/$(BASE).typ TGT=$(BASE).html

# ----------------
# Compile/watch all pages in parallel
# ----------------
compile:
	@ls _src/pages | cut -d. -f1 | xargs -n1 -P4 -I{} $(MAKE) compile-file BASE={}

watch:
	@ls _src/pages | cut -d. -f1 | xargs -n1 -P4 -I{} $(MAKE) watch-file BASE={}
