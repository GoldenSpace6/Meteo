set autoscale xy
set grid nopolar
set xdata time
set timefmt "%m/%d/%y"
set xlabel "Time"
set ylabel "Average value"
set format x "%d/%m/%y %H:%M"
set datafile separator " "
set xtics rotate by 45 right
set timefmt "%s"
plot "sorted_tp.dat" using 1:2 title "Average across all stations" with line
