#!/bin/bash

# Function echoes observation types for given sat system
# Usage:
# getRinexObsTypes head G
# ot=($(getRinexObsTypes head E))
# echo ${x[5]}
function getRinexObsTypes () {
    L1=$(grep -noP "^$2.+SYS / # / OBS TYPES" $1)
    N1=$(echo $L1 | grep -oP "^\d+")
    n=$(echo $L1 | grep -oP " \d{1,2} ")
    if [ $n -gt 12 ]; then
        N2=$(echo "$N1+1"| bc)
        L2=$(sed -n "$N2 p" $1)
    else
        L2=""
    fi
    L="$L1$L2"
    echo "$L" | grep -oP "[C|L|D|S]\d."    
}

# Function to echo number of obs typer for given sat system
# Usage:
# getRinexObsTypesNumber head G
# n=($(getRinexObsTypesNumber head E))
function getRinexObsTypesNumber () {
    L=$(grep -oP "^$2.+SYS / # / OBS TYPES" $1)
    echo $L | grep -oP " \d{1,2} "
}

function getRinexSats () {
    grep -oP "^$2\d{2}" $1 | sort -u
}