#!/bin/bash

set -xeuo pipefail

# apt install pandoc texlive-base texlive-latex-recommended texlive texlive-latex-extra texlive-xetex

export PANDOC=$( which pandoc )
if [ -z "$PANDOC" ]; then
    which docker && { export PANDOC="docker run --rm -v $PWD:/source astralfrontier/pandoc:2.9.2"; }
fi
[ -n "$PANDOC" ] || { echo "No pandoc found!"; exit 1; }

# Usage: runPandoc input-file priority template
function runPandoc() {
    local INPUT=${1}
    local OUTPUT_BASE=${INPUT##*/}
    local OUTPUT=dist/$2${OUTPUT_BASE%.md}.pdf
    local TEMPLATE=${3:-default}
    $PANDOC "$INPUT"            \
        -o "$OUTPUT"            \
        --data-dir pandoc       \
        --template "$TEMPLATE"  \
        --pdf-engine=xelatex    \
        -f markdown             \
        # 
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
