#!/bin/bash

# Function to return array of line numbers where pattern is matched
#
# Usage: 
# getMatchLines JAB1065M.19o "END OF HEADER"
# 
# When used in script use following array syntax:
# matchedLines=($(getMatchLines JAB1065M.19o "END OF HEADER"))
# firstMatch=${matchedLines[0]}
function getMatchLines() { 
    grep -n -oE "$2" "$1" | grep -oP "\d+:" | grep -oP "\d+"
}