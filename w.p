reset
set terminal jpeg
set output "OutputGraphiques/out_w.jpeg"
set autoscale xy
set grid
set xlabel "Longitude"
set ylabel "Latitude"
set xtics norotate
plot "sorted_wind.dat" using 5:4:($2*5):($3*5) "%lf %lf %lf %lf,%lf" title "Mean wind" with vectors
