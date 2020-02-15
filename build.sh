#!/bin/bash

set -xeuo pipefail

# Usage: runPandoc $INPUT $OUTPUT $TEMPLATE
function runPandoc() {
    local INPUT=${1}
    local OUTPUT=${2}
    local TEMPLATE=${3:-default}
    pandoc "$INPUT"             \
        -o "$OUTPUT"            \
        --data-dir pandoc       \
        --template "$TEMPLATE"  \
        #-f gfm                  \
        #--pdf-engine=xelatex    \
        
}

runPandoc input.md output.latex
#runPandoc output.tex output.pdf
#cp output.pdf /mnt/c/Users/opens/Downloads