#!/bin/sh
#SBATCH --time=4:00:00
# mail alert at end of execution
#SBATCH --mail-type=END
# send mail to this address
#SBATCH --mail-user=sergio.hernandez@epfl.ch

echo "Called data_process.sh script:"
echo 'Loading modules'
source /ssoft/spack/bin/slmodules.sh -r stable -v

module load intel/17.0.2
module load intel-mkl/2017.2.174
module load intel-mpi/2017.2.174
module load espresso/6.1.0-mpi

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

 5  ! X-R-Γ-A-M --> |X—R|M—A

    0.0 0.5 0.0    20

    0.0 0.5 0.5    20

    0.0 0.0 0.0    20

    0.5 0.5 0.5    20

    0.0 0.0 0.5    20


EOF

echo "  recalculating omega(q) from C(R)..."
srun matdyn.x < matdyn.in > matdyn.out
echo " matdyn.x done"

cat > plotband.in <<EOF
bto.freq
0 600
freq.plot
freq.ps
0.0
50.0 0.0

EOF

echo "  writing the phonon dispersions in freq.plot..."
plotband.x < plotband.in > /dev/null
echo " plotband.x done"

cat > gnuplot.tmp <<EOF
set encoding iso_8859_15
set terminal postscript enhanced solid color "Helvetica" 20
set output "bto.dispersions.ps"
#
set key off

set xrange [0:4.280239]
dim=450
set yrange [0:dim]
set arrow from 1,0. to 1,dim nohead  lw 2
set arrow from 2,0. to 2,dim nohead  lw 2
set arrow from 1.5,0. to 1.5,dim nohead  lw 2
set arrow from 3.4142,0. to 3.4142,dim nohead  lw 2
set ylabel "frequency (cm^{-1})"
unset xtics
lpos=-15
set label "{/Symbol G}" at -0.05,lpos
set label "X" at 0.95,lpos
set label "W" at 1.45,lpos
set label "X" at 1.95,lpos
set label "{/Symbol G}" at 3.37,lpos
set label "L" at 4.1897,lpos

plot "freq.plot" u 1:2 w l lw 3
EOF
echo "  creating the postscript file bto.dispersion.ps..."
gnuplot gnuplot.tmp

echo " postscript done"


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
