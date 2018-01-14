#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=28
#SBATCH --time=1:00:00

source /ssoft/spack/bin/slmodules.sh -r stable -v             

module load intel/17.0.2
module load intel-mkl/2017.2.174
module load intel-mpi/2017.2.174
module load espresso/6.1.0-mpi


for file in *pwi; do
	title="${file%.*}"
	
	echo " running the scf calculation at cutoff" ${ec}  " Ryd"
	${exe_dir}srun pw.x < ${title}.pwi > ${title}.pwo $
	rm -f *wfc*
	rm -f *mix*
	rm -f *hub*
done


