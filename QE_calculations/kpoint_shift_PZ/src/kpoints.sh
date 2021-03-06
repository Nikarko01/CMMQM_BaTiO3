#!/bin/bash

psp_dir=../../PSP_DIR
wrk_dir='.'

for k in 2 4 6 8 10
do

ec=50
fact=8
ecrho=$((ec*fact))

cat > input.in << EOF

&CONTROL
        calculation = 'scf',
	      title = 'cubic BaTiO3 at 7.40 lattice parameter. xc=PZ'
        restart_mode = 'from_scratch',
        !iprint = 10,
        prefix = 'bto',
        pseudo_dir = '${psp_dir}'
        outdir = '${wrk_dir}'
        tstress = .TRUE.,
        tprnfor = .TRUE.,
/

&SYSTEM
       ibrav = 1,
       celldm(1) =  7.40 ,
       nat = 5,
       ntyp = 3,
       ecutwfc = ${ec},
       ecutrho = ${ecrho},
       nbnd = 24,
/

&ELECTRONS
        mixing_mode = 'plain',
        mixing_beta = 0.6,
        conv_thr = 1.0D-12,
/

ATOMIC_SPECIES
O   15.99  O.pz-van_ak.UPF
Ti  47.88 Ti.pz-sp-van_ak.UPF
Ba 137.33 Ba.pz-sp-hgh.UPF

ATOMIC_POSITIONS {crystal}
 Ba  0    0    0
 Ti 1/2  1/2  1/2
 O   0   1/2  1/2
 O  1/2   0   1/2
 O  1/2  1/2   0

K_POINTS {automatic}
 $k $k $k   1 1 1

EOF

echo " running the scf calculation at k points" $k $k $k 
${exe_dir}/pw.x < input.in > bto_pz_a7.40_k${k}.out

done

