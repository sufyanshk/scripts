#Copyright (C) 2020 Sufyan M. Shaikh
#For plotting COARSE E vs. V graph using gnuplot

#set datafile separator ','
set encoding utf8
set terminal postscript eps enhanced color font "Helvetica-Bold,24"
set output 'summary1.eps'
set title 'E vs. Lattice parameter COARSE'
#show title
set tics scale 1 
set zeroaxis
set mxtics
set xlabel 'Lattice Parameter ({\305})'
set ylabel 'Energy (eV)'

plot 'summary1.csv' using ($1):($5) with linespoints lw 3 ps 2 title "eV"