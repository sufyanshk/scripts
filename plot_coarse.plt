#Copyright (C) 2020 Sufyan M. Shaikh
#For plotting COARSE E vs. V graph using gnuplot
set encoding utf8
set terminal postscript eps enhanced 
set output 'summary1.eps'
set title 'E vs. Lattice parameter COARSE' font 'Arial,18'
show title
set tics scale 1 
set zeroaxis
set mxtics
set xlabel 'Lattice Parameter ({\305})' font 'Arial,18'
set ylabel 'Energy (eV)' font 'Arial,18'

#stats 'summary1.csv' using 1:5 nooutput
#set label 1 'Lattice parameter' center at first STATS_pos_min_y, STATS_min_y point pt 7 ps 1 offset -6,1.5

plot 'summary1.csv' using ($1):($5) with linespoints lw 3 ps 2 title "eV"
#plot 'summary1.csv' using ($1):($5) w lp title 'eV'
