#!/bin/bash
p=0
t=0
h=0
m=0
w=0
sort="avl"
#g=0
#a=0

OIFS=$IFS

# ---- Checking and saving option ----
while getopts "f:t:p:whmFGSAOQd:-:" option; do
    case "${option}" in
        f) #File
            echo ${OPTARG}
            if [ ! -f ${OPTARG} ] || [[ ${OPTARG} != *.csv ]]; then 
                echo "File must exist and be a csv"
                exit 1
            fi
            if [ ! -r "${OPTARG}" ]; then
                echo "File is not readable"
                exit 1
            fi
            file=${OPTARG};;
        t) #Temperature
            if [ $OPTARG -ne 1 ] && [ $OPTARG -ne 2 ] && [ $OPTARG -ne 3 ]; then
                echo "Temperature argument must be 1,2 or 3, use --help"
                exit 1
            fi
            t=${OPTARG};;
        p) #Pressure
            if [ $OPTARG -ne 1 ] && [ $OPTARG -ne 2 ] && [ $OPTARG -ne 3 ]; then
                echo "Pressure argument must be 1,2 or 3, use --help"
                exit 1
            fi
            p=${OPTARG};;
        w) #Wind
            w=1;;
        h) #Height
            h=1;;
        m) #Humidity
            m=1;;
        F | G | S | A | O | Q) #Region
            region=${option};;
        d) #Date
            if [[ ${OPTARG} != ????-??-??,????-??-?? ]]; then
                echo "Date argument must be in format YYYY-MM-DD,YYYY-MM-DD"
                exit 1
            fi
            d=${OPTARG};;
        -)
            case "${OPTARG}" in
                help) #Help
                    echo "exit 1 > inpropper use of option
exit 2 > missing option"
                    exit 0;;
                tab | avl | abr) #Sorting Algorithme
                    sort=${OPTARG};;
                *)
                    echo "Wrong option on --${OPTARG}, use --help"
                    exit 1;;
            esac;;
        *)
            echo "Wrong option on ${option}, use --help"
            exit 1;;
    esac
done
#echo $OPTIND
#shift $((OPTIND-1))
if [ -z $file ]; then
    echo "Missing file, use -f" 
    exit 2
fi
if ((t == 0 && p == 0 && w == 0 && h == 0 && m == 0)); then
    echo "Missing option -p -t -w -h or -m, use --help"
    exit 2
fi

# ---- Filtering Data ----
ffile=$file
if [ ! -z $d ]; then
    IFS=","
    set -- $d
    dmin=$(date -d $1 +%s)
    dmax=$(date -d $2 +%s)
    
    head -n1 $file > filtered_meteo_date.csv
    IFS=$'\n'
    for i in $(tail -n+2 $ffile);do
        set -- $(echo $i | tr ";" "\n")
        if (( $(date -d $2 +%s) >= $dmin && $(date -d $2 +%s) <= $dmax ));then
            echo $i >> filtered_meteo_date.csv
        fi
    done
    ffile="filtered_meteo_date.csv"
fi

IFS=$OIFS

echo "file = $ffile"
echo "p = $p"
echo "t = $t"
echo "h = $h"
echo "w = $w"
echo "m = $m"
echo "region = $region"
echo "dmin = $dmin , dmax = $dmax"
echo "sort = $sort"
