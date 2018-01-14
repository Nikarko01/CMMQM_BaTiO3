#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=28
#SBATCH --time=1:00:00

source /ssoft/spack/bin/slmodules.sh -r stable -v             

module load intel/17.0.2
module load intel-mkl/2017.2.174
module load intel-mpi/2017.2.174
module load espresso/6.1.0-mpi

fullinput=$(readlink -f *pwi)
baseinput=$(basename "$fullinput")
title="${baseinput%.*}"

echo STARTING AT `date`

srun pw.x < ${title}.pwi > ${title}.pwo
rm -f *wfc*
rm -f *mix*
rm -f *hub*

echo FINISHED at `date`
