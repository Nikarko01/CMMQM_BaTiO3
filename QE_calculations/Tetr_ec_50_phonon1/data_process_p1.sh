#!/bin/sh
#SBATCH --nodes=1
#SBATCH --ntasks=28
#SBATCH --time=3:01:00

echo "Called data_process.sh script:"
echo 'Loading modules'
source /ssoft/spack/bin/slmodules.sh -r stable -v             

module load intel/17.0.2
module load intel-mkl/2017.2.174
module load intel-mpi/2017.2.174
module load espresso/6.1.0-mpi

echo DATA PROCESS STARTING AT `date`

cat > q2r.in <<EOF
 &input
        fildyn='bto.dyn',
        zasr='simple',
        flfrc='bto.fc'
/
EOF

echo "  transforming C(q) => C(R)..."
srun q2r.x < q2r.in > q2r.out
echo " q2r.x done"

cat > matdyn.in <<EOF
 &input
        asr='simple',
        amass(1)=15.99,
        amass(2)=47.88,
        amass(3)=137.33,
        flfrc='bto.fc', ! Force costants file from p2r
        flfrq='bto.freq', ! Output requencies
        q_in_band_form=.true., ! q points are given in band form
 /

 5 ! Γ-X-M-Γ-Z --> Γ—X—M—Γ—Z (seekpath), Z—R—A—Z missing
   0.0   0.0   0.0    15
   0.0   0.5   0.0    15
   0.5   0.5   0.0    15
   0.0   0.0   0.0    15
   0.0   0.0   0.5    15

EOF

echo "  recalculating omega(q) from C(R)..."
srun matdyn.x < matdyn.in > matdyn.out
echo " matdyn.x done"

cat > plotband.in <<EOF
bto.freq
0 600     ! min max energy range plot
freq.plot ! output
freq.ps	  ! output
0.0       ! Fermi energy taken from pw
50.0 0.0  ! delta E - the smallest step | Fermi energy plot level
EOF

echo "  writing the phonon dispersions in freq.plot..."
plotband.x < plotband.in > /dev/null
echo " plotband.x done"

cat > phdos.in <<EOF
 &input
        asr='simple',
        dos=.true. 
        amass(1)=15.99,
        amass(2)=47.88,
        amass(3)=137.33,
        flfrc='bto.fc',
        fldos='bto.phdos',
        nk1=6,
        nk2=6,
        nk3=6
 /
EOF

echo "  calculating phonon DOS ..."
srun matdyn.x < phdos.in > phdos.out
echo " DOS done"

cat > gnuplot1.tmp <<EOF
set encoding iso_8859_15
set terminal postscript enhanced solid color "Helvetica" 20
set output "bto.phdos.ps"
#
set key off
set xrange [0:450]
set xlabel "frequency (cm^{-1})"
set ylabel "DOS"
plot 'bto.phdos' u 1:2 w l lw 3 
EOF
echo "  generating plot of phonon_dos in the file bto.phdos.ps..."
gnuplot gnuplot1.tmp

echo " gnuplot done"

echo DATA PROCESS FINISHED at `date`
