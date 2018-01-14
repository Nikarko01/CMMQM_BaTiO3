# Folder:

* _filename_.pwi  : input filename for next computation
* _filename_.pwo  : output filename of a computation
* _filename_.pwif : means already exist an output so no need to recompute

# Run 1:

## Previous errors

> slurmstepd: error: task/cgroup: unable to add task[pid=92349] to memory cg '(null)'
> slurmstepd: error: task/cgroup: unable to add task[pid=92289] to memory cg '(null)'
## Changes

* I tried as in _/geom_opt_try2_ to use the script [_run_pw.sh_][run]
 * [_ecut.sh_][ecut] only creates the _*.pwi_ files. 
 * The _*.pwi_ files are sent to jobs by [_run_pw.sh_][run] which  
  executes them in background with:
  > srun pw.x < ${title}.pwi > ${title}.pwo $

 [run]: ecut.sh
 [ecut]: run_pw.sh 

## Errors

not working: output files:
* [CRASH][1]
* [slurm-307950.out][2]

[1]: src/try1_CRASH
[2]: src/try1_slurm-307950.out
### Interpretation and _future_ changes

* CRASH: file ../PSP_DIR/O.pz-van_ak.UPF not found
 * forgot that is in ../../PSP_DIR/O.pz-van_ak.UPF  
 change that.
* slurm-307950.out: application called MPI_Abort(MPI_COMM_WORLD, 1)
 * error comes from [c++/c syntax](https://www.open-mpi.org/doc/v2.0/man3/MPI_Abort.3.php)
 * only useful this found is this [forum](http://mpi-forum.org/docs/mpi-2.2/mpi22-report/node192.htm)
 * see [MPI_abort definition](https://www.mpich.org/static/docs/v3.1/www3/MPI_Abort.html)

# Run 2:

## Changes
 see previous section...

## Errors

not working: output files:
* [CRASH][1]
* [slurm-307950.out][2]

[1]: src/try2_CRASH
[2]: src/try2_slurm-307950.out
## Interpretation

* CRASH: tmp_dir cannot be opened
 * No idea why...![smiley][smiley]
* slurm-307955.out: 
 1. mkdir fail: [13] Permission denied 
 2. srun: error: f105: tasks 13,19: Exited with exit code 1
 3. In: PMI_Abort(1, application called MPI_Abort(MPI_COMM_WORLD, 1) - process 19)
  1. maybe I shouldn't name a dyrectory /src
  2. not found on [fortran error page][ferror]
  3. Alway the same error as before

 [smiley]: src/emoji.png
 [ferror]: http://geco.mines.edu/guide/Run-Time_Error_Messages.html

# Run 3:

## Changes
1. let's change /src mane to /scrmd (source markdown)

## Errors
* as always 

# Run 4 

## Changes
* Let's try only one _*pwi_ file as input

## Errors 
* As always

# Run 5:

## Changes

* outdir = './' instead of a non-existing directory  
into _*pwi_ files.

## Errors 

only BT_ec_60.pwo worked out

# Run 6: 

## Changes
New [run file][new] with effectively working for loop
on all files:
>input=$(ls --format=single-column)
>titles="${input%.*}"
>
>for file in *pwi; do
>	title = "${file%.*}"
>
>	srun pw.x < ${title}.pwi > ${title}.pwo
>	rm -f *wfc*
>	rm -f *mix*
>	rm -f *hub*
>done

[new]: allrun_pw.sh
## Errors

> /var/spool/slurmd/job308099/slurm_script: line 10: title: command not found
> /var/spool/slurmd/job308099/slurm_script: line 12: .pwi: File o directory non esistente

# Run 7: 

## Changes
File [allrun_pw.sh](allrun_pw.sh) has been changed due to errors:

* Eliminate space in _title = "${file%.*}"_ near the equality sign
* Eliminate usless lines
 > input=$(ls --format=single-column)
 > titles="${input%.\*}"

## Errors

* Every tested _*pwi_ file (30,40,50,100) has empty _*pwo_ output file.
* slurm-308105.out:
 1. slurmstepd: error: execve(): pw.x: No such file or directory  
--> similar encoundered issues: [1](http://thread.gmane.org/gmane.comp.distributed.slurm.devel/8511)
 2. srun: error: f033: tasks 1,14,21,25: Exited with exit code 2  
--> ENDFILE error [(ref)][ferror]

# Run 8:

## Changes

Add forgotten module loading lines into [allrun_pw.sh](allrun_pw.sh).

>source /ssoft/spack/bin/slmodules.sh -r stable -v             

>module load intel/17.0.2
module load intel-mkl/2017.2.174
module load intel-mpi/2017.2.174
module load espresso/6.1.0-mpi

