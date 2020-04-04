#Copyright (C) 2020 Sufyan M. Shaikh
#!/bin/bash

#THIS SCRIPT SHOULD BE USED FOR FINAL LATTICE PARAMETER CALCULATION ONLY
#CHECK THE POSCAR FILE SECTION, VERIFY THAT THE EACH ELEMENT AND ITS RESPECTIVE
#ATOMS ARE CORRECTLY DEFINED.

rm summary2.csv summary_EvsV_fine.csv

#Define no. of cores
n_cores=8

#Name of the system
sys_name="V"

#Energy cut-off value (for structure relaxation take 1.3x the ENMAX of POTCAR)
e_cutoff=295

#Initial POSCAR, POTCAR and KPOINTS will be taken from the folder.
#Later only the POSCAR will be changed.
#Rest of the files will be used as it is.

#POSCAR will be changed for every new lattice parameter and the values will be used to calculated the energies.
#These energies will be saved in summary_EvsV_fine.csv file, which will be later used to plot E vs V graph...
#from which precise lattice parameter will be found out.

#Enter the probable range of lattice parameter. This is from the earlier VASP run.
#For better accuracy, keep the step size in for loop as 0.01
for i in $(seq 2 0.01 4) 
do
	sed -i "1s/.*/$sys_name/" POSCAR
	sed -i "2s/.*/$i/" POSCAR
	echo "a= $i"
	mpirun \-n $n_cores vasp_std > log 
	
	#This will write in to file summary2.csv file.
	E=`awk '/F=/ {print $0}' OSZICAR` ; echo $i kp2 $E >> summary2.csv
done

#This will seperate the columns by commas and only the 
#lattice parameter, Energies will be printed to summary_EvsV_fine.csv file.
awk '{print $1","$2","$5}' summary2.csv > summary_EvsV_fine.csv

#Plots the fine E vs. V using gnuplot
gnuplot plot_fine.plt

echo "$sys_name : E vs. V \"FINE\" CALCULATION FINISHED"
printf "\n"
