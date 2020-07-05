#Copyright (C) 2020 Sufyan M. Shaikh
#Plots E vs. K-points for precise lattice parameter using gnuplot

#set datafile separator ','
set encoding utf8 
set terminal postscript eps enhanced color font "Helvetica-Bold,24"
set output 'summary3.eps' 
set title "E vs. K-points"
#show title
set mxtics
set xlabel "K-points"
set ylabel "Energy (eV)"

stats 'summary3.csv' using 1:3 nooutput
set key title sprintf("a = %f",STATS_pos_min_y)

plot 'summary3.csv' using ($2):($5) with linespoints lw 3 ps 2 title "eV"
