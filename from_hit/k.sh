#!/bin/bash
rm WAVECAR
#k convergence 
for i in 2 4 6 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 ; 
do
cat >KPOINTS <<!
KPOINTS File
0
Monkhorst
$i $i $i
0 0 0
!

	#set -x	
	echo "k = $i" ; 
	
	b=$(llsubmit GotoVirgo) ;
	sleep 10 ;
	#echo $b ;
	c=$(echo $b | awk '{ 
	ret=match($0,".in.") 
	rwt=match($0,"\" has")
	rqt=rwt-(ret+4)
	subs=substr($0,(ret+4),rqt)
	print subs
	}') ;
	
	#echo $c ;

	d=1 ;
	#echo "outside d = $d" ;	
	until [ $d -eq 0 ]
	do
		b=$(llq $c) ;
		sleep 10 ;
		#echo "llq is $b" ;
		d=$(echo $b | awk '{
		if ($0 ~ /mm17s003/)
			{print 1}
		else
			{print 0}
		}') ;
		#echo "d = $d" ;
	done

	#E=`awk '/F=/ {print $0}' OSZICAR` ;
	E=$(tail -1 OSZICAR) ;
	
	echo $i $i $i $E >> k_conv ;
	
done

#set +x
#awk '{print $1 "\t" $(NF-5)}' k_conv >> k_plot ;