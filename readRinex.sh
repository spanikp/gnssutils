#!/bin/bash
. shellutils.sh
. rinexutils.sh

# Separate header
eohl=($(getMatchLines "$1" "END OF HEADER"))
head -n"$eohl" $1 > head

# Get number of observations per system
n=$(getRinexObsTypesNumber head $2)
ot=$(getRinexObsTypes head $2 | tr '\n' ';' | sed 's/.$//')

# Discover epochs
epo=($(grep -oP "^>.+[.]\d+" $1 | sed 's/> //g' | sed -E 's/\s+/;/g'))
epi=($(grep -noP "^>" $1 | grep -oP "\d+"))
sv=($(getRinexSats $1 $2))

# Create empty SV files
CSVhead="year;month;day;hour;minute;second;${ot}"
for sat in "${sv[@]}"
do
    echo $CSVhead > $sat
done

# Looping epochs
for ies in "${epi[@]}"
    do
        ((ies+=1))
        echo $ies
    done
