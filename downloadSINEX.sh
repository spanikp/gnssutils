#!/bin/bash

# Script usage:
# ./downloadSINEX.sh ftp://igs.bkg.bund.de/EUREF/products/ 1930 1935 sut sut-download
server=$1 # with last "/"
from=$2
to=$3
center=$4
dirToStore=$5

# Prepare dir to store
function makeDir() {
    if [ ! -d $1 ]; then
        echo "Folder '$1' not exist! Create empty directory..."
        mkdir -p $1
    fi
}
makeDir $dirToStore
makeDir "$dirToStore/weekly"

for week in $(seq $from $to)
do 
    echo "===== Downloading week $week ====="
    p=$server$week/
    wget -q --no-remove-listing $p # produce .listing and index.html

    # Loop for daily solution in given week
    names=($(grep -oP "$center\d{4}[0-6].snx.Z" .listing))
    for f in "${names[@]}"
    do
        url=$p$f
        echo "Downloading '$f' into '$dirToStore' ... "
        wget -q "$url" -O "$dirToStore/$f"
        if [ $? == 0 ]; then
            echo "Unzipping '$f' ... "
            gzip -d "$dirToStore/$f"
        else
            echo "File '$f' not downloaded."
        fi
    done

    # Handle weekly solution
    namesWeekly=($(grep -oP "$center\d{4}7.snx.Z" .listing))
    for f in "${namesWeekly[@]}"
    do
        url=$p$f
        echo "Downloading '$f' into '$dirToStore/weekly' ... "
        wget -q "$url" -O "$dirToStore/weekly/$f"
        if [ $? == 0 ]; then
            echo "Unzipping '$f' ... "
            gzip -d "$dirToStore/weekly/$f"
        else
            echo "File '$f' not downloaded."
        fi
    done

    # Cleanup 
    rm index.html .listing
done