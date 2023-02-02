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
        m) #Moisure
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

awk -F"[;T]" '{system("date -d "$2" +%s")+substr($3,0,2)*3600}' titleless_meteo.csv > simpledate.csv
#awk -F"[;T:-]" '{print $2$3$4$5}' titleless_meteo.csv > simpledate.csv
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
        awk -F";" '{print $2,$12,$13,$14}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o sorted_tp.dat --$sort
        #Station;moy;min;max
        awk -F' ' 'BEGIN{test=0; moy=0;nb=1} test!=$1 {print $1" "moy/nb;moy=0;nb=0;} {test=$1;moy+=$2;nb++;} END{printprint $1" "moy/nb}' sorted_tp.dat >sorted_tp.dat
        #GNUPLOT :
        gnuplot
        load 'tp1.p'
        q
        ;;
    2)
        awk -F";" '{print $1,$12}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o sorted_tp.dat --$sort
        #Station;moy;min;max
        #GNUPLOT :
        gnuplot
        load 'tp2.p'
        q
        ;;
    3)
        awk -F";" '{print $1,$2,$3,$12}' $ffile > temp1.csv
        ./CSVsorting -f temp1.csv -o temp.dat --$sort
        awk -F";" '{print $1,$2,$3,$12}' temp1.csv > temp.csv
        ./CSVsorting -f temp.csv -o sorted_tp.dat --$sort
        #Date;Station,real Date,moy
        #GNUPLOT :
        gnuplot
        load 'tp3.p'
        q
        ;;
esac
case $p in
    1)
        awk -F";" '{print $2,$4,$8,$9}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o sorted_tp.dat --$sort
        #Station;mer;pre sta;var
        #GNUPLOT :
        gnuplot
        load 'tp1.p'
        q
        ;;
    2)
        awk -F";" '{print $1,$8}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o sorted_tp.dat --$sort
        #Station;pre sta
        #GNUPLOT :
        gnuplot
        load 'tp2.p'
        q
       ;;
    3)
        awk -F";" '{print $1,$2,$3,$8}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o sorted_tp.dat --$sort
        #Date;Station,real Date,pre sta
        #GNUPLOT :
        gnuplot
        load 'tp3.p'
        q
        ;;
esac
if (($w == 1));then 
    awk -F";" '{print $2,$5,$6,$11}' $ffile > temp.csv
    ./CSVsorting -f temp.csv -o sorted_wind.dat --$sort
    #Station,direction,vitesse,coord
    #GNUPLOT :
    gnuplot
    load 'w.p'
    q
fi
if (($h == 1));then 
    awk -F";" '{print $15,$11}' $ffile | awk '!seen[$0]++' > height.csv
    ./CSVsorting -f temp.csv -o sorted_height.dat --$sort -r
    #Height,Coord
    #GNUPLOT :
    gnuplot
    load 'h.p'
    q
fi
if (($m == 1));then 
    awk -F";" '{print $7,$11}' $ffile > temp.csv
    ./CSVsorting -f temp.csv -o sorted_moisture.dat --$sort -r
    #Moisture,Coord
    #GNUPLOT :
    gnuplot
    load 'm.p'
    q
fi



IFS=$OIFS
rm temp.csv
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
