#Copyright (C) 2020 Sufyan M. Shaikh
#!/bin/bash
#@ output     = output.out
#@ error      = error.err
#@ job_type   =  MPICH
#@ node = 1
#@ tasks_per_node = 24
#@ class      = Medium128
#@ environment = COPY_ALL
#@ queue

#THIS SCRIPT SHOULD BE USED FOR INITIAL STRUCUTRAL AND SHAPE RELAXATION
#CHECK THE POSCAR FILE SECTION, CONFIRM THE ELEMENTS AND THEIR RESPECTIVE
#ATOMS ARE CORRECTLY DEFINED

if [ -f summary1.csv ];then
        rm summary1.csv
        if [ -f summary_EvsV_coarse.csv ]; then
                rm summary_EvsV_coarse.csv
        fi
fi

#Define no. of cores
n_cores=16

#Name of the system
sys_name="NbMo"

#Energy cut-off value (for structure relaxation take 1.3x the ENMAX of POTCAR)
e_cutoff=300

#INCAR file will be written here
cat >INCAR <<!
SYSTEM = $sys_name
ISTART = 0
NCORE = 4
ALGO = FAST
ISPIN = 2 
NSIM = 4
ENCUT = $e_cutoff
IBRION = 2
NSW = 100
NELM = 200
NELMIN = 3 
ISIF = 3
ISMEAR = 1
SIGMA = 0.2
PREC = Accurate
LWAVE = .FALSE.
LREAL = AUTO
LCHARG = .FALSE.
LVTOT = .FALSE.
!

#Initial POSCAR, POTCAR and KPOINTS will be taken from the folder.
#Later only the POSCAR and INCAR files will be changed.
#Rest of the files will be used as it is.

#First relaxation will take place.
#This is the first run of the VASP for structure relaxation.
echo "FIRST RELAXATION STARTED" && touch "qualifiers_started"
mpirun -np $n_cores vasp > log
echo "FIRST RELAXATION OVER" && touch "qualifiers_over"

#After the first run, the CONTCAR file will be copied to POSCAR.
cat CONTCAR > POSCAR
echo "CONTCAR COPIED TO POSCAR"

#Again the relaxation will be done with new POSCAR.
echo "VASP SECOND RUN STARTED" && touch "semifinals_started"
mpirun -np $n_cores vasp > log
echo "SECOND RUN OF VASP IS OVER" && touch "semifinals_over"

#For getting correct energy values, one more calculation will be done with TETRAHEDRON method (ISMEAR=-5).
#There won't be any relaxation for this run (IBRION=-1).
#INCAR file will be written here
echo "INCAR FILE WILL BE EDITED"
sed -i "s/ISMEAR.*/ISMEAR\ =\ -5/g" INCAR
sed -i "s/IBRION.*/IBRION\ =\ -1/g" INCAR
sed -i "s/PREC.*/PREC\ =\ High/g" INCAR
sed -i "s/ISIF.*/ISIF\ =\ 2/g" INCAR
sed -i "/NSW.*/d" INCAR

echo "STARTING FINAL ENERGY CALCULATION FOR CORRECT ENERGY VALUES" && touch "finals_started"
mpirun -np $n_cores vasp > log
echo "FINAL ENERGY CALCULATION IS OVER" && touch "finals_over"

echo "STARTING E vs V CALCULATIONS" && touch "EV_started"

#POSCAR will be changed for every new lattice parameter and the values will be used to calculated the energies.
#These energies will saved in SUMMARY file, which will be later used to plot E vs V graph.

for i in $(seq 1 1 10) 
do
	sed -i "2s/.*/$i/" POSCAR
	echo "a= $i"
	mpirun -np $n_cores vasp > log
	
	#This will write in to file summary.csv file.
	#The columns will be sepereated with spaces.
	E=`awk '/F=/ {print $0}' OSZICAR` ; echo $i kp $E >> summary1.csv
done

#This will seperate the columns by commas and only the 
#lattice parameter, K-points and Energies will be printed to summary_EvsV_coarse.csv file.
awk '{print $1","$2","$5}' summary1.csv > summary_EvsV_coarse.csv

#Plots the E vs. V using gnuplot
gnuplot plot_coarse.plt

echo "$sys_name : E vs. V \"COARSE\" CALCULATIONS ARE FINISHED" && touch "EV_over"
printf "\n"
