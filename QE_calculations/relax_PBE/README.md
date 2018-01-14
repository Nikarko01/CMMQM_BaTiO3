# Folder:

* _filename_.pwi  : input filename for next computation
* _filename_.pwo  : output filename of a computation
* _filename_.pwif : means already exist an output so no need to recompute

# Run 1:

## comments

The [output][1] doesn't seem to have changed the atomic positions.

[1]: src/run1_BT_relax_PBE.pwo

# Run 2:

## Changes

Atomic positions changed from
> Ti 1/2  1/2  1/2
to 
> Ti 0.51  1/2  1/2

## comments

# Run 3:

Atomic positions changed to
> Ti 0.53  1/2  1/2

and added time flags to [run script][2]
>echo STARTING AT `date`
>echo FINISHED at `date`

[2]: run_pw.sh