#!/bin/bash

set -xeuo pipefail

# apt install pandoc texlive-base texlive-latex-recommended texlive texlive-latex-extra texlive-xetex

# Usage: runPandoc $INPUT $OUTPUT $TEMPLATE
function runPandoc() {
    local INPUT=${1}
    local OUTPUT=${2}
    local TEMPLATE=${3:-default}
    pandoc "$INPUT"             \
        -o "$OUTPUT"            \
        --data-dir pandoc       \
        --template "$TEMPLATE"  \
        --latex-engine=xelatex  \
        #-f gfm                  \
        #
}

runPandoc ./rules/rules.md rules.pdf default
runPandoc ./playbooks/idiot.md idiot.pdf playbook

# Combine PDFs
gs -sDEVICE=pdfwrite            \
    -dCompatibilityLevel=1.4    \
    -dPDFSETTINGS=/default      \
    -dNOPAUSE -dQUIET -dBATCH   \
    -dDetectDuplicateImages     \
    -dCompressFonts=true        \
    -r150                       \
    -sOutputFile=WITCH.pdf      \
    rules.pdf                   \
    idiot.pdf

cp WITCH.pdf /mnt/c/Users/opens/Downloads