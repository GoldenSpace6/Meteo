#!/bin/bash
p=0
t=0
h=0
m=0
w=0
sort="avl"

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
            if [ $OPTARG != 1 ] && [ $OPTARG != 2 ] && [ $OPTARG != 3 ]; then
                echo "Temperature argument must be 1,2 or 3, use --help"
                exit 1
            fi
            t=${OPTARG};;
        p) #Pressure

            if [ $OPTARG != 1 ] && [ $OPTARG != 2 ] && [ $OPTARG != 3 ]; then
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
#ffile=$file
#if [ -n "$d" ] || [ -n "$region" ];then
#    #Date
#    if [ -n "$d" ]; then
#        IFS=","
#        set -- $d
#        dmin=$(date -d $1 +%s)
#        dmax=$(date -d $2 +%s)
#    fi
#    #Region
#    if [ -n "$region" ]; then
#        case $region in
#            # Create a Area that contain the whole region
#            # [minLatitude,maxLatitude,minLongitude,maxLongitude]
#            F)
#                Area=(38.5 51.5 -6.5 10.5);;
#            G)
#                Area=(1.5 7 -55.5 -51);;
#            S)
#                Area=(46 48 -58 -54);;
#            A)
#                Area=(9 29 -92 -55);;
#            O)
#                Area=(-60 7 20 120);;
#            Q)
#                Area=(-90 -60 -180 180);;
#            *)
#                echo Error Wrong region
#                exit 1
#        esac
#    fi
#
#    head -n1 $file > filtered_meteo.csv
#    IFS=$'\n'
#    lm=1
#    ght=0
#    loop=$(tail -n+2 $ffile)
#    for i in $loop;do
#        IFS=";"
#        HOLA=(${i})
#
#        #echo "$1 ; $2 ; $3 ; $4 ; $5 ; $6 ; $7 ; $8 ; $9 ; ${10}"
#        save=1
#        lm=$(( lm + 1 ))
#
#        if [ $lm -eq "20" ];then
#            echo $ght
#            lm=0
#            ght=$(( ght + 1 ))
#        fi
#        
#        #Date
#        if [ -n "$d" ]; then
#            tempdate=`date -d ${HOLA[1]} +%s`
#            if (( $tempdate < $dmin || $tempdate > $dmax )); then
#                save=0
#            fi
#        fi
#        #Region
#        if [ -n "$region" ] && [ $save -eq 1 ]; then
#            IFS=","
#            GPS=(${HOLA[9]})
#            #GPS=(${HOLA[9]//,/$";"})
#            #GPS=(${10//,/;}) #replace , by ; then turn it into an array
#            if [ `echo "${GPS[0]}<${Area[0]}||${GPS[0]}>${Area[1]}||${GPS[1]}<${Area[2]}||${GPS[1]}>${Area[3]}" | bc` = 1 ]; then
#                save=0
#            fi
#        fi
#        #Write on temporary file
#        if [ $save -eq 1 ]; then
#            echo $i >> filtered_meteo.csv
#        fi
#    done
#    ffile="filtered_meteo.csv"
#fi


# ---- Filtering Data ---- V2
ffile=$file

#awk -F";" '{print substr( $0, 0, index($0,";")+1 )    substr($0, index(substr($0,0,index($0,";")+2),";")+1, 10000 ) }' meteo_filtered_data_v1.csv


awk -F";" '{$2=substr(system("date -d "substr($2,0,10)" +%s"),5,30);print $0}' meteo_filtered_data_v1.csv

awk -F";" '{print $0";"substr(system("date -d "substr($2,0,10)" +%s"),5,30)}' meteo_filtered_data_v1.csv

if [ -n "$d" ] || [ -n "$region" ];then
    #Date
    if [ -n "$d" ]; then
        IFS=","
        set -- $d
        dmin=$(date -d $1 +%s)
        dmax=$(date -d $2 +%s)
    fi
    for i in $loop;do
        IFS=";"
        HOLA=(${i})

        #echo "$1 ; $2 ; $3 ; $4 ; $5 ; $6 ; $7 ; $8 ; $9 ; ${10}"
        save=1
        lm=$(( lm + 1 ))

        if [ $lm -eq "20" ];then
            echo $ght
            lm=0
            ght=$(( ght + 1 ))
        fi
        
        #Date
        if [ -n "$d" ]; then
            tempdate=`date -d ${HOLA[1]} +%s`
            if (( $tempdate < $dmin || $tempdate > $dmax )); then
                save=0
            fi
        fi
    done

    #Region
    if [ -n "$region" ]; then
        case $region in
            # Create a Area that contain the whole region
            # [minLatitude,maxLatitude,minLongitude,maxLongitude]
            F)
                Area=(38.5 51.5 -6.5 10.5);;
            G)
                Area=(1.5 7 -55.5 -51);;
            S)
                Area=(46 48 -58 -54);;
            A)
                Area=(9 29 -92 -55);;
            O)
                Area=(-60 7 20 120);;
            Q)
                Area=(-90 -60 -180 180);;
            *)
                echo Error Wrong region
                exit 1
        esac
        dd=$(date -d $5)
        #awk -F";" -v '{print substr($2,0,10)}' $ffile > filetemp.csv

        #awk -F";" -v date="$(date +%Y-%m-%d)" -v temp="(substr($2,0,10))" '{print temp}' meteo_filtered_data_v1.csv 

        #awk -F";" '{test=substr($2,0,10);print $test}' meteo_filtered_data_v1.csv 
    

        awk -F";" 'substr($10,0,index($10,",")-1)-('${Area[0]}')>0 && substr($10,0,index($10,",")-1)-('${Area[1]}')<0 && substr($10,index($10,",")+1,100)-('${Area[2]}')>0 && substr($10,index($10,",")+1,100)-('${Area[3]}')<0 {print $0}' $ffile > filetemp.csv
        ffile=filetemp.csv
    fi
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
