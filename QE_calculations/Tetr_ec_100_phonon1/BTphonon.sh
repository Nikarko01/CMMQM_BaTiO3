#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=28
#SBATCH --time=9:01:00

# mail alert at end of execution
#SBATCH --mail-type=END

# send mail to this address
#SBATCH --mail-user=nicola.barchi@epfl.ch

#	Script running the scf and DFPT calculations
#	output on .pwo and .pho files. 
#	

echo 'Loading modules'
source /ssoft/spack/bin/slmodules.sh -r stable -v             

module load intel/17.0.2
module load intel-mkl/2017.2.174
module load intel-mpi/2017.2.174
module load espresso/6.1.0-mpi

# ******************************
# **          parser          **
# ******************************

phononly=false

while [ ! $# -eq 0 ]
do
        case "$1" in
                --help | -h)
                        echo "**Phonon calculation shell script**"
                        echo " "
                        echo "BTphonon.sh [options]"
                        echo " "
                        echo "options:"
                        echo "-h, --help             show brief help"
                        echo "-p, --phononly         does not repeat scf calculations"
                        echo " "
                        exit
                        ;;
                --phononly | -p)
                        phononly=true
                        ;;

        esac
        shift
done


# *************************************
# **   self-consistent calculation   **
# *************************************
if [ "$phononly" = true ] ; then

echo "Phonon only mode active"

else
echo SCF STARTING AT `date`

srun pw.x < BT.scfPBE.pwi > BT.scfPBE.pwo

echo SCF FINISHED at `date`

fi

# ************************************************
# **             phonon calculation             **
# ************************************************

echo DFPT STARTING at `date`

srun ph.x < bto.ph.in > bto.ph.out

echo DFPT FINISHED at `date`