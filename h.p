reset
set terminal jpeg
set output "OutputGraphiques/out_h.jpeg"
set autoscale xy
set grid front
set xyplane relative 0
set xlabel "Longitude"
set ylabel "Latitude"
set palette defined (0 0 0 0.5, 1 0 0 1, 2 0 0.5 1, 3 0 1 1, 4 0.5 1 0.5, 5 1 1 0, 6 1 0.5 0, 7 1 0 0, 8 0.5 0 0)
set xtics norotate
set view map
set pm3d map interpolate 8,8 #flush begin nohidden3d
set dgrid3d 50, 50
splot "sorted_height.dat" using 3:2:1 "%lf %lf,%lf" title "Height" with pm3d
