#!/bin/sh
#SBATCH --time=01:00:01
echo "Called proc_frequencies.sh script: process frequencies"
echo 'Loading modules'
source /ssoft/spack/bin/slmodules.sh -r stable -v             

module load intel/17.0.2
module load intel-mkl/2017.2.174
module load intel-mpi/2017.2.174
module load espresso/6.1.0-mpi

echo DATA PROCESS STARTING AT `date`
cat > plotband.in <<EOF
bto.freq
0 600     ! min max energy range plot
freq.plot ! output
freq.ps	  ! output
0.0       ! Fermi energy taken from pw
50.0 0.0  ! delta E - the smallest step | Fermi energy plot level
EOF

echo "  writing the phonon dispersions in freq.plot..."
plotband.x < plotband.in > plotband.out
echo " plotband.x done"

echo DATA PROCESS FINISHED at `date`
