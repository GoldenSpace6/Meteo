set autoscale xy
set grid front
set xlabel "Longitude"
set ylabel "Latitude"
#set zrange [22:*]
#set palette defined (0 0 0 0.5, 1 0 0 1, 2 0 0.5 1, 3 0 1 1, 4 0.5 1 0.5, 5 1 1 0, 6 1 0.5 0, 7 1 0 0, 8 0.5 0 0)
set palette
set xtics rotate by 90 right
set view map
set pm3d map interpolate 8,8
set dgrid3d 50, 50
splot "sorted_moisture.dat" using 3:2:1 "%lf %lf,%lf" title "Moisture" with pm3d
