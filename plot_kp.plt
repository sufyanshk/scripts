#Plots E vs. K-points for precise lattice parameter using gnuplot
set encoding utf8 
set terminal postscript eps enhanced
set output 'summary3.eps' 
set title "E vs. K-points" font "Arial,18"
show title
set mxtics
set xlabel "K-points" font "Arial,18"
set ylabel "Energy (eV)" font "Arial,18"

stats 'summary3.csv' using 1:3 nooutput
set key title sprintf("a = %f",STATS_pos_min_y)

plot 'summary3.csv' using ($2):($5) with linespoints lw 3 ps 2 title "eV"
