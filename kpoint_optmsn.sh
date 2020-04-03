#Copyright (C) 2020 Sufyan M. Shaikh
#!/bin/bash

#THIS FILE SHOULD ONLY BE USED FOR OPTIMISING KPOINTS...
#AFTER THE E vs V HAS BEEN OPTIMISED AND...
#THE PRECISE LATTICE PARAMETER HAS BEEN FOUND OUT.

rm summary3.csv summary_with_kp.csv

#Name of the system
sys_name="V"

#Define no. of cores
n_cores=8

#Precise lattice parameter, found out from earlier runs of VASP.
i=2.9

#POSCAR with precise lattice parameter will be written here.
cat >POSCAR <<!
	$sys_name
	$i
	1 0 0
	0 1 0
	0 0 1
	V
	2
	Direct
	0 0 0
	0.5 0.5 0.5
!

#KPOINTS will be changed and the respective energies will be calculated.
#Put the range of K-point in which you want to get the energy values.
for kp in $(seq 4 1 20)
do
	cat > KPOINTS<<!
	K-Points
	 0
	Monkhorst Pack
	$kp $kp $kp
	0 0 0
!

	echo "a= $i K-points=$kp $kp $kp"
	
	#Energy will be calculated for every KPOINT
	mpirun \-n $n_cores vasp_std > log 
	
	#Lattice parameter, K-points and energy will be written in the "summary3.csv" file
	E=`awk '/F=/ {print $0}' OSZICAR` 
	echo $i $kp $E >> summary3.csv
done

#This will seperate the columns with commas and the final file will "summary_with_kp.csv".
awk '{print $1","$2","$5}' summary3.csv >> summary_with_kp.csv

#Plots E vs. K-points for given precise lattice parameter
gnuplot plot_kp.plt

echo "$sys_name : K-point optimisation finished"
