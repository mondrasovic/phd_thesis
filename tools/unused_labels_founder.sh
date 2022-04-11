#!/bin/bash

# A script that finds unused labels within multipe "*.tex" files.

# Author: Milan Ondrasovic, <milan.ondrasovic@gmail.com>

cd ..

get_declared_labels() {
    grep --include="*.tex" -Rho -P "label{[a-zA-Z0-9_:]*}" |\
        cut -c 7- |\
        rev | cut -c 2- | rev |\
        sort 
}

get_used_labels() {
    grep --include="*.tex" -Rho -P "ref{[a-zA-Z0-9_:]*}" |\
        cut -c 5- |\
        rev | cut -c 2- | rev |\
        sort | uniq
}

# Report different lines only from the left source.
comm -23 <(get_declared_labels) <(get_used_labels)
