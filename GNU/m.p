reset
set terminal jpeg
set output "OutputGraphiques/out_m.jpeg"
set autoscale xy
set grid front
set xlabel "Longitude"
set ylabel "Latitude"
set cbrange [*:*]
set palette
set xtics norotate
set view map
set pm3d map interpolate 8,8
set dgrid3d 50, 50
splot "sorted_moisture.dat" using 3:2:1 "%lf %lf,%lf" title "Moisture" with pm3d
