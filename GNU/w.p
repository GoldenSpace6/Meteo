set grid nopolar
set datafile separator ";"
set xtics rotate by 90 right
set xrange [*:*]
set yrange [*:*]





plot "sorted_wind.dat" using 0:3
