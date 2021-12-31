#!/bin/bash

# A script that finds unused figures within multipe "*.tex" files according to
# available directories containing figures.

# Author: Milan Ondrasovic, <milan.ondrasovic@gmail.com>

cd ../tex/

get_stored_figs() {
    find figures -name "*.*" | sort
}

get_used_figs() {
    grep --include="*.tex" -Rho -P "figures/[a-zA-Z0-9/_.]*" | sort | uniq
}

# Report different lines only from the left source.
comm -23 <(get_stored_figs) <(get_used_figs)
