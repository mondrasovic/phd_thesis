#!/bin/bash

# A script that finds unused glossaries within multipe "*.tex" files.

# Author: Milan Ondrasovic, <milan.ondrasovic@gmail.com>

cd ..

get_declared_glossaries() {
    {
        cat ./tex/custom/glossaries.tex | grep -ho -P "newacronym{[a-zA-Z_]*}" | awk -F[{}] '{ print $2 }';
        cat ./tex/custom/glossaries.tex | grep -ho -P "newacronym\[.*\]{[a-zA-Z_]*}" | awk -F[{}] '{ print $8 }'
    } |\
    sort
}

get_used_glossaries() {
    {
        grep --include "*.tex" -Rho -P "gls{[a-zA-Z_]*}";
        grep --include "*.tex" -Rho -P "glspl{[a-zA-Z_]*}"
    } |\
    awk -F[{}] '{ print $2 }' |\
    sort | uniq
}

# Report different lines only from the left source.
comm -23 <(get_declared_glossaries) <(get_used_glossaries)
