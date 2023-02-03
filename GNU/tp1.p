reset
set terminal jpeg
set output "OutputGraphiques/out_tp1.jpeg"
set autoscale xy
set xlabel "ID de station"
set ylabel "Mesure"
set datafile separator " "
set xrange [*:*]
set yrange [*:*]
set xtics rotate by 90 right
color = "#80E0A080"
#set colorbox vertical origin screen 0.9, 0.2 size screen 0.05, 0.6 front noinvert bdefault
#:xticlabels(3)

plot "sorted_tp.dat" using 0:3:4:xticlabels(1) with filledcurve fc rgb color title "Min/max", \
'' using 0:2 with line title "Average"
