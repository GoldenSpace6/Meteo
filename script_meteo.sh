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
            if [ ! -f "${OPTARG}" ] | [ ! *.csv == "${OPTARG}" ]
            then
                echo Wrong file, use --help
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
                    exit 0;;
                tab | avl | abr)
                    sort=${OPTARG};;
                *)
                    echo Wrong Argument on -${OPTARG}, use --help
                    exit 1;;
            esac;;
        *)
            echo Wrong Argument on ${option}, use --help
            exit 1;;
    esac
done
#shift $((OPTIND-1))
if [ -z $file ]; then
    echo Missing file, use --help
    exit 2
fi
if ((t == 0 && p == 0 && w == 0 && h == 0 && m == 0)); then
    echo Missing Argument, use --help
    exit 2
fi
echo "file = $file"
echo "p = $p"
echo "t = $t"
echo "h = $h"
echo "w = $w"
echo "m = $m"
echo "region = $region"
echo "sort = $sort"
