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
ISIF = 4
ISMEAR = 1
SIGMA = 0.2
PREC = Accurate
LWAVE = .FALSE.
LREAL = AUTO
LCHARG = .TRUE.
LVTOT = .FALSE.
!


for a in $(seq 3 0.1 3.7) 
do
		sed -i "2s/.*/$a/" POSCAR
		echo "a= $a"
		
		echo "FIRST RELAXATION STARTED" && touch "qualifiers_started"
		mpirun -np $n_cores vasp >> log
		echo "FIRST RELAXATION OVER" && touch "qualifiers_over"
		
		echo "ICHARGE = 1" >> INCAR
		echo "VASP SECOND RUN STARTED" && touch "semifinals_started"
		mpirun -np $n_cores vasp >> log
		echo "SECOND RUN OF VASP IS OVER" && touch "semifinals_over"
		
		sed -i "s/ISMEAR.*/ISMEAR\ =\ -5/g" INCAR
		sed -i "s/IBRION.*/IBRION\ =\ -1/g" INCAR
		sed -i "s/ISIF.*/ISIF\ =\ 2/g" INCAR
		mpirun -np $n_cores vasp > log	
		#This will write in to file summary.csv file.
		#The columns will be sepereated with spaces.
		E=`awk '/F=/ {print $0}' OSZICAR` ; echo $a kp $E >> summary1.csv
		sed -i "s/ICHARG.*//g" INCAR
	}
awk '{print $1","$2","$5}' summary1.csv > EOS.csv

echo "$sys_name : EOS CALCULATIONS ARE FINISHED" && touch "EOS_over"
printf "\n"
