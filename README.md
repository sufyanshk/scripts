# VASP structure relaxation files.
(VASP and Gnuplot should be installed prior to running these scripts)
(MPIRUN is used for parrallel runs of vasp_std)

These scripts are used to do strucutrual relaxations and get precise
lattice parameter using Vienna Ab-initio Simulaiton Package (VASP) using bash and gnuplot scripts.\
The .plt files are used for plotting "E vs. k-points" and "E vs. lattice parameter"
plots.\
\
POSCAR and KPOINTS files are updated during runtime of the respective scripts. Kindly edit the *evsvol_coarse.sh*, *evsvol_fine.sh* and *kp_optimisation.sh* files before runnign the scripts.
