#!/bin/bash
p=0
t=0
h=0
m=0
w=0
region=0
sort="avl"
#dmin=0
#dmax=0

#g=0
#a=0

while getopts "f:t:p:whmFGSAOQd:-:" option; do
    case "${option}" in
        f)
            if [ ! -f "${OPTARG}" ] | [ ! *.csv == "${OPTARG}" ] #csv
            then
                echo wrong file
                exit 1
            fi
            file=${OPTARG};;
        t)
            t=${OPTARG};;
            #((t == 15 || t == 75)) || echo lol
        p)
            p=${OPTARG};;
        w)
            w=1;;
        h)
            h=1;;
        m)
            m=1;;
        F | G | S | A | O | Q)
            region=${option};;
        d)
            d=${OPTARG};;
        -)
            case "${OPTARG}" in
                help)
                    echo try random thing, it might work
                    exit 0
                    ;;
                tab | avl | abr)
                    sort=${OPTARG}
                    ;;
                *)
                    echo Wrong Argument on -${OPTARG}
                    ;;
            esac
            ;;
        *)
            echo Wrong Argument on ${option}
            ;;
    esac
done
#shift $((OPTIND-1))
echo "p = ${p}
t = ${t}
h = ${h}
w = ${w}
m = ${m}
region = ${region}
sort = ${sort}"
