#Copyright (C) 2020 Sufyan M. Shaikh
#For plotting FINE E vs. V graph using gnuplot
set encoding utf8
set terminal postscript eps enhanced 
set output 'summary2.eps'
set title 'E vs. Lattice parameter FINE' font 'Arial,18'
show title
set tics scale 1 
set zeroaxis
set mxtics
set xlabel 'Lattice Parameter ({\305})' font 'Arial,18'
set ylabel 'Energy (eV)' font 'Arial,18'

stats 'summary2.csv' using 1:5 nooutput
set label 1 sprintf("%f",STATS_pos_min_y) center at first STATS_pos_min_y,STATS_min_y point pt 13 ps 2 offset 1,1 

plot 'summary2.csv' using ($1):($5) with linespoints lw 3 ps 2 title "eV"
