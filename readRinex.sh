#!/bin/bash
. shellutils.sh
. rinexutils.sh

# Separate header
eohl=($(getMatchLines "$1" "END OF HEADER"))
head -n"$eohl" $1 > head

# Get number of observations per system
n=$(getRinexObsTypesNumber head $2)
#echo $n

# Discover epochs
epo=($(grep -oP "^>.+[.]\d+" $1 | sed 's/> //g' | sed -E 's/\s+/,/g'))
epi=($(grep -noP "^>" $1 | grep -oP "\d+"))

#for ies in "${epi[@]}"
#    do
#        ((ies+=1))
#        echo $ies
#    done
    
echo ${epi[0]}





#./readRinex.sh JAB1065M.19o G