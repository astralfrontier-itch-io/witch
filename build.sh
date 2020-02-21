#!/bin/bash

set -xeuo pipefail

# apt install pandoc texlive-base texlive-latex-recommended texlive texlive-latex-extra texlive-xetex

# Usage: runPandoc $INPUT $OUTPUT $TEMPLATE
function runPandocLocal() {
    local INPUT=${1}
    local OUTPUT=${2}
    local TEMPLATE=${3:-default}
    pandoc "$INPUT"             \
        -o "$OUTPUT"            \
        --data-dir pandoc       \
        --template "$TEMPLATE"  \
        --latex-engine=xelatex  \
        -f gfm                  \
        #
}

function runPandocDocker() {
    local INPUT=${1}
    local OUTPUT=${2}
    local TEMPLATE=${3:-default}
    docker run --rm -v $PWD:/source astralfrontier/pandoc:2.9.2 \
        "$INPUT"                \
        -o "$OUTPUT"            \
        --data-dir pandoc       \
        --template "$TEMPLATE"  \
        --pdf-engine=xelatex  \
        -f gfm                  \
        #
}

# Usage: runPandoc input-file priority template
function runPandoc() {
    local INPUT=${1}
    local OUTPUT_BASE=${INPUT##*/}
    local OUTPUT=dist/$2${OUTPUT_BASE%.md}.pdf
    runPandocDocker "$INPUT" "$OUTPUT" "$3"
}

[ -d dist ] || { mkdir dist; }
rm -f dist/*

find rules -type f | while read i; do runPandoc $i B default; done
find playbooks -type f | while read i; do runPandoc $i P playbook; done

# Combine PDFs
gs -sDEVICE=pdfwrite            \
    -dCompatibilityLevel=1.4    \
    -dPDFSETTINGS=/default      \
    -dNOPAUSE -dQUIET -dBATCH   \
    -dDetectDuplicateImages     \
    -dCompressFonts=true        \
    -r150                       \
    -sOutputFile=WITCH.pdf      \
    dist/*.pdf
