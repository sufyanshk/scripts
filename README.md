# VASP structure relaxation
VASP and Gnuplot should be installed prior to running these scripts.
Other interesting repositories can be found on my personal website: <a href="https://sufyanshk.github.io/">sufyanshk.github.io</a>
MPIRUN is used for parrallel runs of `vasp_std`.

These are bash and gnuplot scripts to do strucutrual relaxations and get precise lattice parameter using Vienna Ab-initio Simulaiton Package (VASP).  
POSCAR and KPOINTS files are updated during runtime of the respective scripts. Kindly edit the `evsvol_coarse.sh`, `evsvol_fine.sh` and `kp_optimisation.sh` files before running the scripts.  
The `.plt` files are used for plotting `E vs. k-points` and `E vs. lattice parameter`
plots.

Steps:
1. Put KPOINTS, POSCAR and POTCAR files.
2. Edit the `evsvol_coarse.sh` file and write in it:
	* Energy cut-off
	* Crystal-system name (POSCAR system for which you want to calculate the lattice parameter)
	* No. of cores on which you want to run the VASP calculations
3. `nohup evsvol_coarse.sh &` so that the calculations run in the background.
4. Check the `nohup.out` file for the output messages. (If `summary1.eps` file is generated then it means your calculations are over)
5. Edit the `evsvol_fine.sh` similar to step-2. Reduce the step size of lattice parameter change.
6. `nohup evsvol_fine.sh &` so that the calculations run in the background.
7. Check the `nohup.out` file for the output messages. (If `summary2.eps` file is generated then it means your calculations are over)
8. Edit the `kpoint_optmsn.sh` file for desired K-point density.
9. `nohup kpoint_optmsn.sh &` so that the calculations run in the background.
10. Check the `nohup.out` file for the output messages. (If `summary3.eps` file is generated then it means your calculations are over)

# Disclaimer
This program is not affiliated with VASP.  
You are free to modify it, but do so at your own risk.  
 
