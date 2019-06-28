#!/bin/bash

getDateFromWeekDoy() {
    week=$(echo $1 | grep -oP "\d{4}") 
    dow=$(echo $1 | grep -oP "\d{4}\K\d")
    sow=$(echo "$dow*86400 + 43200" | bc) 
    echo $week $sow | ./convertTime.py "%Y;%m;%d;%H;%M;%S"
}

# Function to extract X,Y,Z,errX,errY,errZ from unzipped SINEX file
# Coordinates are parsed from SINEX part "SOLUTION/ESTIMATE" 
# Output format:
# sinexFilename,station,X,Y,Z,errX,errY,errZ
getCoordinatesFromSinex() {
    file=$1
    stat=$2
    
    # Convert weekDow to date
    weekDow=$(echo $file | grep -oP "\d{5}") 
    d=$(getDateFromWeekDoy $weekDow)

    lb=$(grep -e "^+SOLUTION/ESTIMATE" -o -n $file | grep -Po "\d+")
    le=$(grep -e "^-SOLUTION/ESTIMATE" -o -n $file | grep -Po "\d+")
    
    crdt=( STAX STAY STAZ )
    crd=()
    std=()
    for ct in "${crdt[@]}"
    do
        sed -n "$lb,$le p" "$file" > temp
        c=$(grep -e "$ct   $stat" temp | grep -o -P "\d.\d{15}E[+]\d{2}")
        s=$(grep -e "$ct   $stat" temp | grep -o -P " .\d{6}E[+|-]\d{2}"| sed 's/\s/0/g')
        crd+=("$c")
        std+=("$s")
    done
    if test -f temp; then # Cleanup temp
        rm temp
    fi
    echo "$1;$2;$d;${crd[0]};${crd[1]};${crd[2]};${std[0]};${std[1]};${std[2]}"
}
#getCoordinates FILENAME STATION

# Main script execution
# example: ./getStatCrd.sh folderWithSinexFiles stationIdentifier
sinexFolder=$1
stat=$2

files=($(ls -l $sinexFolder | grep -oP "[a-z]{3}\d{5}.snx"))
for sinex in "${files[@]}"
do
    sp="$sinexFolder/$sinex"
    if test -f $sp; then 
        #echo $sp
        #echo $stat
        getCoordinatesFromSinex $sp $stat
    fi
done
