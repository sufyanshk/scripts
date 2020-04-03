#!/bin/bash

rm WAVECAR
#2 % tension/comprssion step

for i in 375 400 425 450 475 ; do
cat >INCAR <<!
SYSTEM = Ni3Al_Ordered 
#PREC = Accurate
ENCUT = $i
IBRION = 2
NSW = 1
#NELM = 100 default is 60 which seems fine
ICHARG = 2
EDIFF = 1E-7
EDIFFG = 1E-7
ISTART = 0
ISMEAR = 1
SIGMA = 0.1
ISIF = 2
ISPIN = 2
MAGMOM = 0 3*0.606
LORBIT = 11
#LREAL = .FALSE.
NPAR = 4
#ISYM = 0
#NEDOS = 3001
LWAVE = .FALSE.
LCHARG = .FALSE.
LVTOT = .FALSE.
ADDGRID = .TRUE.
#NBANDS = 64
!

echo "Ecut = $i";

b=$(llsubmit GotoVirgo) ;
sleep 10 ;
c=$(echo $b | awk '{ 
ret=match($0,".in.") 
rwt=match($0,"\" has")
rqt=rwt-(ret+4)
subs=substr($0,(ret+4),rqt)
print subs
}') ;


#next 4 lines are for debugging 
#h=$(llq $c) ;
#echo $h ;
d=1 ;
#echo $d ;

until [ $d -eq 0 ]
	do
		b=$(llq $c) ;
		sleep 10 ;
		d=$(echo $b | awk '{
		if ($0 ~ /mm17s003/)
		{print 1}
		else
		{print 0}
		}') ;
	done

#E=`awk '/F=/ {print $0}' OSZICAR` ;
E=$(tail -1 OSZICAR) ;

echo $i $E >> Ecut_conv
done

#awk '{print $1 "\t" $(NF-5)}' Ecut_conv >> Ecut_plot ;
