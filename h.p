set autoscale xy
set grid front
set xyplane relative 0
set ylabel "Longitude"
set xlabel "Latitude"
#set palette rgbformulae 20,21,22
#set palette grey
set palette defined (0 0 0 0.5, 1 0 0 1, 2 0 0.5 1, 3 0 1 1, 4 0.5 1 0.5, 5 1 1 0, 6 1 0.5 0, 7 1 0 0, 8 0.5 0 0)
#set xrange [*:*]
#set yrange [*:*]
set xtics rotate by 90 right
set view map
set pm3d map interpolate 8,8 #flush begin nohidden3d
#set colorbox vertical origin screen 0.9, 0.2 size screen 0.05, 0.6 front noinvert bdefault

set dgrid3d 50, 50
splot "sorted_height.dat" using 3:2:1 "%lf %lf,%lf" title "Height" with pm3d
