#!/bin/bash

# A script that finds unused citations within multipe "*.tex" files according to
# some "*.bib" files.

# Author: Milan Ondrasovic, <milan.ondrasovic@gmail.com>

cd ..

get_declared_refs() {
    # 1.) Retrieve all the matches of @[...] keys.
    # 2.) Remove the "@[article,misc,..]{" string from the beginning.
    # 3.) Remove the "}" character from the end.
    # 4.) Sort the output.
    cat tex/references.bib |\
        grep -P '@[a-zA-Z]*{[a-zA-Z0-9]*' |\
        awk -F '{' '{ print $2 }' |\
        rev | cut -c 2- | rev |\
        sort
}

get_used_refs() {
    # 1.) Find all the matches of citations within LaTeX files.
    # 2.) Remove the "\cite{" string from the beginning.
    # 3.) Remove the "}" character from the end.
    # 4.) Split citations containing multiple keys, e.g., \cite{k1, k2, k3}.
    # 5.) Strip white spaces. Given the example above, the string would be split
    #     into "k1", " k2" and "k3".
    # 6.) Sort the output and remove duplicates.
    grep --include="*.tex" -Rho -P "cite{[a-zA-Z0-9, ]*}" |\
        cut -c 6- |\
        rev | cut -c 2- | rev |\
        tr "," "\n" |\
        tr -d " " |\
        sort | uniq
}

# Report different lines only from the left source.
comm -23 <(get_declared_refs) <(get_used_refs)
