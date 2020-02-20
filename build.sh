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
cp rules.pdf /mnt/c/Users/opens/Downloads