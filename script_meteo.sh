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

# ----------------------------------------------
# ------------- Filtering Data V2 --------------
# ----------------------------------------------

tail -n+2 $file > titleless_meteo.csv
echo Removed head

awk -F"[;T:-]" '{print $2$3$4$5}' titleless_meteo.csv > simpledate.csv
echo created date

paste -d';' simpledate.csv titleless_meteo.csv > meteo_data_w_date.csv
echo appended date

ffile="meteo_data_w_date.csv"

# ---- Date
if [ -n "$d" ]; then
    IFS=",-"
    set -- $d
    dmin=$1$2$3"00"
    dmax=$4$5$6"00"
    awk -F";" '$1>'$dmin' && $1<'$dmax' {print $0}' $ffile > filtered_date.csv
    ffile="filtered_date.csv"
fi

# ---- Region
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

    awk -F"[;,]" '$11-('${Area[0]}')>0 && $11-('${Area[1]}')<0 && $12-('${Area[2]}')>0 && $12-('${Area[3]}')<0 {print $0}' $ffile > filtered_area.csv
    ffile="filtered_area.csv"
fi

# -------------------------------------------
# ----------------- Sorting -----------------
# -------------------------------------------

case $t in
    1)
        cut $ffile -f2,12,13,14 -d";" > temperature.csv
        ./CSVsorting -f temperature.csv -o sorted_temperature.dat --$sort
        #Station;moy;min;max
        ;;
    2)
        cut $ffile -f1,12 -d";" > temperature.csv
        ./CSVsorting -f temperature.csv -o sorted_temperature.dat --$sort
        #Station;moy;min;max
        ;;
    3)
        cut $ffile -f1,2,3,12 -d";" > temperature.csv
        #./CSVsorting -f temperature.csv -o sorted_temperature.dat --$sort
        #Date;Station,real Date,moy
        ;;
esac
case $p in
    1)
        cut $ffile -f2,4,8,9 -d";" > pressure.csv
        ./CSVsorting -f pressure.csv -o sorted_pressure.dat --$sort
        #Station;mer;pre sta;var
        ;;
    2)
        cut $ffile -f1,8 -d";" > pressure.csv
        ./CSVsorting -f pressure.csv -o sorted_pressure.dat --$sort
        #Station;pre sta
       ;;
    3)
        cut $ffile -f1,2,3,8 -d";" > temperature.csv
        ./CSVsorting -f pressure.csv -o sorted_pressure.dat --$sort
        #Date;Station,real Date,pre sta
        ;;
esac
if (($w == 1));then 
    cut $ffile -f2,5,6,11 -d";" > wind.csv
    ./CSVsorting -f wind.csv -o sorted_wind.dat --$sort
    #Station,direction,vitesse,coord
fi
if (($h == 1));then 
    cut $ffile -f15,11 -d";" > height.csv
    ./CSVsorting -f height.csv -o sorted_wind.dat --$sort -r
    #Height,Coord
fi
if (($m == 1));then 
    cut $ffile -f7,11 -d";" > humidity.csv
    ./CSVsorting -f humidity.csv -o sorted_wind.dat --$sort -r
    #Humidity,Coord
fi

# -------------------------------------------
# ----------------- GnuPlot -----------------
# -------------------------------------------


IFS=$OIFS
rm temperature.csv
rm pressure.csv
rm wind.csv
rm height.csv
rm humidity.csv
#kill titleless_meteo.csv simpledate.csv meteo_data_w_date.csv filtered_date.csv filtered_area.csv 
#kill temperature.csv sorted_temperature.csv pressure.csv sorted_pressure.csv wind.csv sorted_wind.csv height.csv sorted_height.csv humidity.csv sorted_humidity.csv
# ---- Test ----
echo "file = $ffile"
echo "p = $p"
echo "t = $t"
echo "h = $h"
echo "w = $w"
echo "m = $m"
echo "region = $region"
echo "dmin = $dmin , dmax = $dmax"
echo "sort = $sort"
