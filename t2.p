set autoscale xy
set grid nopolar
set style data lines
set xlabel "Time"
set ylabel "Average value"
set datafile separator " "
set xtics rotate by 90 right
plot "sorted_temperature.dat" using 1:2 title "Average"
