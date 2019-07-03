#!/bin/bash
. shellutils.sh
. rinexutils.sh

# Separate header
eohl=($(getMatchLines "$1" "END OF HEADER"))
head -n"$eohl" $1 > head

# Get number of observations per system
nOt=$(getRinexObsTypesNumber head $2)
ot=$(getRinexObsTypes head $2 | tr '\n' ';' | sed 's/.$//')
rinexLength=$(wc -l < $1)

# Discover epochs
epo=($(grep -oP "^>.+[.]\d+" $1 | sed 's/> //g' | sed -E 's/\s+/;/g'))
epi=($(grep -noP "^>" $1 | grep -oP "\d+" | bc))
epi+=($((++rinexLength)))
sv=($(getRinexSats $1 $2))

# Create empty SV files
CSVhead="year;month;day;hour;minute;second;${ot}"
for sat in "${sv[@]}"
do
    echo $CSVhead > $sat.csv
done

# Looping epochs
epochSeq="${#epo[@]}"; ((epochSeq--))
((nOt--))
for i in $(seq 0 $epochSeq)
do
    progress=$(echo "scale=2; 100*($i+1)/($epochSeq+1)" | bc)
    echo -ne "Reading progress: $progress%\\r"
    idxS=${epi[$i]};
    ((idxS++))
    ii=$i;
    ((ii++)) 
    idxE=${epi[$ii]};
    ((idxE--))
    
    sed -n "$idxS,$idxE p" "$1" > temp
    svList=($(grep -oP "$2\d{2}" temp | sort -u))
    for s in "${svList[@]}"
    do
        line=$(grep "$s" temp | grep -oP "(\d+[.]\d{3})|( {14,})" | tr '\n' ';' | sed -E 's/\s+//g' | sed 's/.$//' )    
        #echo $line
        noCommas=$(echo $line | grep -o ";" | wc -l)
        if [ $noCommas -ne $nOt ]; then
            nCommasToAdd=$(echo $nOt - $noCommas | bc)
            commasToAdd=$(printf '%*s' $nCommasToAdd '' | tr ' ' ';')
            line="$line$commasToAdd"
        fi
        #echo "$line"
        echo "${epo[i]};$line" >> $s.csv
    done
done
