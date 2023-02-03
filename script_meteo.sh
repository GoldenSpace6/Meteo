#!/bin/bash
p=0
t=0
h=0
m=0
w=0
sort="avl"

OIFS=$IFS
# Compile C
cd sort
make
make clean
mv CSVsorting ../
cd ../
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
                    echo 'exit 1 > inpropper use of option \n exit 2 > missing option \n
					-f file Inputed must be a csv\n
                    
					--------- Graph type -----------\n
					-t1 Generate a Graph with each station having a min, max and a average of the temperature\n
					-t2 Generate a Graph with hour having a average of the temperature\n
					-t3 Does nott work\n
					
					-p1 Generate a Graph with each station having a min, max and a average of the pressure\n
					-p2 Generate a Graph with hour having a average of the pressure\n
					-p3 Does not work\n 
					\n
					-w Generate a Graph of each station with their average wind direction\n
					\n
					-h Generate a Graph of each station with their height\n
					\n
					-m Generate a Graph of each station with their moisture\n
					--------- Filtering -----------\n
					-d yyyy-mm-dd,YYYY-MM-DD Remove Value that are not contain between yyyy-mm-dd and YYYY-MM-DD\n
					-g m,M Remove Value that do not have longitute between m and M\n
					-a m,M Remove Value that do not have latitude between m and M\n
					-A -Z
					--------- Sorting Method -----------\n
                    --tab Does not work\n
                    --ABR sort data using ABR sorting\n
                    --AVL sort data using AVL sorting\n
                    
                    --help show this\n
					'
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

# ----------------------------------------------
# ------------- Filtering Data V2 --------------
# ----------------------------------------------

tail -n+2 $file > titleless_meteo.csv
echo Removed head

#awk -F"[;T]" '{system("date -d "$2" +%s")+substr($3,0,2)*3600}' titleless_meteo.csv > simpledate.csv
awk -F";" '{temp=$2; $2=mktime(substr($2,0,4)" "substr($2,6,2)" "substr($2,9,2)" "substr($2,12,2)" 00 00") ; print $0,temp}' titleless_meteo.csv > meteo_data_w_date.csv
#awk -F"[;T:-]" '{print $2$3$4$5}' titleless_meteo.csv > simpledate.csv
echo Created date
#paste -d';' simpledate.csv titleless_meteo.csv > meteo_data_w_date.csv
#echo appended date

ffile="meteo_data_w_date.csv"

# ---- Date
if [ -n "$d" ]; then
    IFS=",-"
    set -- $d
    dmin=$(date -d $1 +%s)
    dmax=$(date -d $2 +%s)
    awk -F" " '$2>'$dmin' && $2<'$dmax' {print $0}' $ffile > filtered_date.csv
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

    awk -F"[ ,]" '$10-('${Area[0]}')>0 && $10-('${Area[1]}')<0 && $11-('${Area[2]}')>0 && $11-('${Area[3]}')<0 {print $0}' $ffile > filtered_area.csv
    ffile="filtered_area.csv"
fi

# -------------------------------------------
# ----------------- Sorting -----------------
# -------------------------------------------
tr ' ' ';' <$ffile > temp3.csv
ffile="temp3.csv"
case $t in
    1)
        awk -F';' '{print $1,$11}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o temp2.csv --$sort
        awk -F' ' '$2!="" {print $0}' temp2.csv > temp.csv
        awk -F' ' 'BEGIN{prev="";moy=0;nb=0;min=100;max=-100} prev!=""&&prev!=$1 {print $1,moy/nb,min,max ;moy=0;nb=0;min=$2;max=$2} min>$2 {min=$2} max<$2 {max=$2} {prev=$1;moy+=$2;nb++} END{print $1,moy/nb,min,max}' temp.csv >sorted_tp.dat
        #Station,moy,min,max
        #GNUPLOT :
        gnuplot --persist GNU/tp1.p 
        ;;
    2)
        awk -F';' '{print $2,$11}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o temp2.csv --$sort
        #Date,moy
        awk -F' ' 'BEGIN{prev="";moy=0;nb=0} prev!=""&&prev!=$1 {print $1,moy/nb ;moy=0;nb=0} {prev=$1;moy+=$2;nb++} END{print $1,moy/nb}' temp2.csv >sorted_tp.dat
        #GNUPLOT :
        gnuplot --persist GNU/tp2.p 
        ;;
    3)
        awk -F';' '{print $2,$1,$11}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o temp2.csv --$sort
        awk -F' ' '{print $2,$1,$3}' temp2.csv > temp.csv
        ./CSVsorting -f temp.csv -o temp2.csv --$sort
        #Station,date,moy
        awk -F' ' 'BEGIN{prev="";moy=0;nb=0} prev!=""&&prev!=$1 {print $1,$2,moy/nb ;moy=0;nb=0} {prev=$1;moy+=$3;nb++} END{print $1,$2,moy/nb}' temp2.csv >sorted_tp.dat
        #GNUPLOT :
        #gnuplot --persist GNU/tp3.p 
        ;;
esac
case $p in
    1)
        awk -F';' '{print $1,$7}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o temp2.csv --$sort
        awk -F' ' '$2!="" {print $0}' temp2.csv > temp.csv
        awk -F' ' 'BEGIN{prev="";moy=0;nb=0;min=100;max=-100} prev!=""&&prev!=$1 {print $1,moy/nb,min,max ;moy=0;nb=0;min=$2;max=$2} min>$2 {min=$2} max<$2 {max=$2} {prev=$1;moy+=$2;nb++} END{print $1,moy/nb,min,max}' temp.csv >sorted_tp.dat
        #Station,moy,min,max
        #GNUPLOT :
        gnuplot --persist GNU/tp1.p 
        ;;
    2)
        awk -F';' '{print $2,$7}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o temp2.csv --$sort
        #Date,pressure
        awk -F' ' 'BEGIN{prev="";moy=0;nb=0} prev!=""&&prev!=$1 {print $1,moy/nb ;moy=0;nb=0} {prev=$1;moy+=$2;nb++} END{print $1,moy/nb}' temp2.csv >sorted_tp.dat
        #GNUPLOT :
        gnuplot --persist GNU/tp2.p 
        ;;
    3)
        awk -F';' '{print $2,$1,$7}' $ffile > temp.csv
        ./CSVsorting -f temp.csv -o temp2.csv --$sort
        awk -F' ' '{print $2,$1,$3}' temp2.csv > temp.csv
        ./CSVsorting -f temp.csv -o temp2.csv --$sort
        #Station,date,moy
        awk -F' ' 'BEGIN{prev="";moy=0;nb=0} prev!=""&&prev!=$1 {print $1,$2,moy/nb ;moy=0;nb=0} {prev=$1;moy+=$3;nb++} END{print $1,$2,moy/nb}' temp2.csv >sorted_tp.dat
        #GNUPLOT :
        #gnuplot --persist GNU/tp3.p 
        ;;
esac
if (($w == 1));then 
    awk -F';' '{print $1,$4,$5,$10}' $ffile > temp.csv
    #awk -F' ' 'BEGIN{prev="";moy=0;nb=1} prev!=""&&prev!=$1 {print $1,moy/nb ;moy=0;nb=0} {prev=$1;moy+=$2;nb++} END{print $1,moy/nb}' 
    ./CSVsorting -f temp.csv -o temp2.csv --$sort
    awk -F' ' 'BEGIN{prev="";moy_lat=0;moy_long=0;nb=0} prev!=""&&prev!=$1 {print $1,moy_lat/nb,moy_long/nb,$4 ;moy_lat=0;moy_long=0;nb=0} {prev=$1;moy_long-=sin($2)*$3;moy_lat-=cos($2)*$3;nb++} END{print $1,moy_lat/nb,moy_long/nb,$4 ;moy_lat=0;moy_long=0;nb=0}' temp2.csv > sorted_wind.dat
    #Station,direction,vitesse,coord
    #Station,dx,dy,coord
    #GNUPLOT :
    gnuplot --persist GNU/w.p 
fi
if (($h == 1));then 
    awk -F';' '{print $14,$10}' $ffile | awk '!seen[$0]++' > temp.csv
    ./CSVsorting -f temp.csv -o sorted_height.dat --$sort -r
    #Height,Coord
    #GNUPLOT :
    gnuplot --persist GNU/h.p 
fi
if (($m == 1));then 
    awk -F';' '$6!="" {print $6,$10}' $ffile | awk '!seen[$0]++' > temp.csv
    ./CSVsorting -f temp.csv -o temp2.csv --$sort -r
    awk -F';' '{print $1}' temp2.csv > sorted_moisture.dat

    #Moisture,Coord
    #GNUPLOT :
    gnuplot --persist GNU/m.p 
fi



IFS=$OIFS
rm meteo_data_w_date.csv
rm temp.csv
rm temp2.csv
rm temp3.csv
rm sorted_temperature.dat
rm sorted_pressure.dat
rm sorted_wind.dat
rm sorted_height.dat
rm sorted_moisture.dat
#kill titleless_meteo.csv simpledate.csv meteo_data_w_date.csv filtered_date.csv filtered_area.csv 
#kill temperature.csv sorted_temperature.csv pressure.csv sorted_pressure.csv wind.csv sorted_wind.csv height.csv sorted_height.csv humidity.csv sorted_humidity.csv
