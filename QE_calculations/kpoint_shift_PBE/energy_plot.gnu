#!/bin/bash

gnuplot -persist << EOF
# Gnuplot script file for plotting data
# This file is called energy_plot.p

set   autoscale                        # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically
set title "Ecut energy convergence xc=PBE"
set xlabel "k points"
set ylabel "Energy [Ry]"

plot    "energy.dat" using 1:2 title 'Convergence' with linespoints
set terminal gif
set output "kpts_conv_PBE.jpg"
plot    "energy.dat" using 1:2 title 'Convergence' with linespoints

EOF