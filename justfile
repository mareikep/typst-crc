set shell := ["bash", "-cu"]

# Variables
project := "crc-2025"
proposal := project
cover := project + "-cover"

# Colors (generated safely using printf)
esc := `printf '\033'`
color-reset := esc + "[0m"
color-red := esc + "[1;31m"
color-green := esc + "[1;32m"
color-yellow := esc + "[1;33m"
color-blue := esc + "[1;34m"
color-magenta := esc + "[1;35m"
color-cyan := esc + "[0;36m"
color-white := esc + "[1;37m"

# OS detection
uname_s := `uname -s`
os_env := `echo "${OS:-}"`  # empty if unset

os_type := if os_env == "Windows_NT" {
  "Windows"
} else if uname_s == "Darwin" {
  "macOS"
} else if uname_s == "Linux" {
  "Linux"
} else {
  "Unknown"
}

# Fallback typst executables
fallback_typst := if os_type == "Windows" {
  "./typst.exe"
} else if os_type == "macOS" {
  "./typst-darwin"
} else if os_type == "Linux" {
  "./typst-linux"
} else {
  "typst"
}

# Check for global typst
global_typst := `command -v typst 2>/dev/null || echo ""`
typst := if global_typst == "" { fallback_typst } else { "typst" }

# Typst version message
typst_version := `typst --version 2>/dev/null || echo "unknown version"`
info_msg := if global_typst == "" {
  "* using executable for " + color-white + os_type + color-reset + ": " + typst + color-green + " *"
} else {
  "* using installed typst version " + color-reset + " " + typst_version + color-green + " *"
}

# Default python command
python := if `which python >/dev/null 2>&1; echo $?` == "0" {
  "python"
} else {
  "python3"
}

# ---------------------------------------------------------------------------

default:
    just all

all:
    just info prepare compile cover docs

info:
    @printf "{{color-cyan}}<{{project}}>{{color-green}} {{info_msg}}{{color-reset}}\n"

watch:
    @printf "{{color-cyan}}<{{project}}>{{color-magenta}} * watching proposal... *{{color-reset}}\n"
    @{{typst}} watch {{proposal}}.typ

compile:
    @printf "{{color-cyan}}<{{project}}>{{color-red}} * single compiling proposal... *{{color-reset}}\n"
    @{{typst}} compile {{proposal}}.typ
    @printf "{{color-cyan}}<{{project}}>{{color-red}} * proposal compiled *{{color-reset}}\n"

cover:
    @printf "{{color-cyan}}<{{project}}>{{color-blue}} * compiling double cover page... *{{color-reset}}\n"
    @{{typst}} compile --ppi 600 --format svg {{cover}}.typ
    @{{typst}} compile --ppi 600 --format png {{cover}}.typ
    @{{typst}} compile --ppi 600 --format pdf {{cover}}.typ
    @printf "{{color-cyan}}<{{project}}>{{color-blue}} * double cover page compiled to output files {{color-reset}}{{cover}}.svg, {{cover}}.png and {{cover}}.pdf {{color-blue}}*{{color-reset}}\n"

prepare:
    @printf "{{color-cyan}}<{{project}}>{{color-yellow}} * preparing document setup... *{{color-reset}}\n"
    @printf "{{color-cyan}}<{{project}}>{{color-yellow}} * using python interpreter: {{color-reset}}{{python}}{{color-yellow}} *{{color-reset}}\n"
    @time {{python}} metadata/read-metadata.py
    @printf "{{color-cyan}}<{{project}}>{{color-yellow}} * preparation complete *{{color-reset}}\n"

debug-home:
    @echo "HOME is: $HOME"

docs:
    @printf "{{color-cyan}}<{{project}}>{{color-blue}} * building documentation... *{{color-reset}}\n"
    @just --justfile=doc/justfile compile
    @printf "{{color-cyan}}<{{project}}>{{color-blue}} * documentation built. Open {{color-reset}}doc/index.html {{color-blue}}in browser. *{{color-reset}}\n"
