set autoscale noextend
set grid nopolar
#set style data lines
set xlabel "ID de station"
set ylabel "Mesure"
set datafile separator " "
set xrange [*:*]
set yrange [*:*]
set xtics rotate by 90 right
color = "#80E0A080"
#set colorbox vertical origin screen 0.9, 0.2 size screen 0.05, 0.6 front noinvert bdefault

plot "sorted_temperature.dat" using 1:2:xticlabels(3) with filledcurve fc rgb color #title "T min max"
