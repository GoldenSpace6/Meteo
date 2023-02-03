reset
set terminal jpeg
set output "OutputGraphiques/out_tp2.jpeg"
set autoscale xy
set grid nopolar
set xdata time
set timefmt "%m/%d/%y"
set xlabel "Time"
set ylabel "Average value"
set format x "%m/%Y"
set datafile separator " "
set xtics rotate by 45 right
set timefmt "%s"
plot "sorted_tp.dat" using 1:2 title "Average across all stations" with line
