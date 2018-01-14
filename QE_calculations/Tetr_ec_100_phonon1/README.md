# Run 1:

## comments 
see [output][out1]
[out1]: src/run1_slurm-309639.out

* BT.scfPBE.pwi file is empty
* pw.x not found

# Run 2:

## Changes

* add **srun**  
in front of **pw.x** and **ph.x** commands
* prewritten inputs

## output comments

BT.scfPBE.pwi file got the input


# Run 3:

stupid error!!

change from:
srun pw.x < BT.scfPBE.pwi > BT.scfPBE.pwi
to 
srun pw.x < BT.scfPBE.pwi > BT.scfPBE.pwo


# Run 4:

## Changes

added _Title line missing from input._ as  
suggested in **bto.ph.out**

## Errors

Time of 1h wasn't enough

# Run 5:

## Changes 

put 9 hours runtime:
there are 28 **bto.wfc** files while only
4 **bto.dyn** file were made in 1 hour.
I supposed it need to build 28 files as well, 
with constant build time --> 7h runtime.
+ 2hours security.

# Run 1 and 2 data processing:

## Errors

See:
* [Run 1 slurm][1]
* [Run 2 slurm][2]
 * [matdyn.out][3] 
 * [q2r.out][4]

[1]: src/pltrun1_slurm-309736.out
[2]: src/pltrun2_slurm-309737.out
[3]: src/pltrun2/matdyn.out
[4]: src/pltrun2/q2r.out

# Run 3 data processing:

## Changes
As always, gib errors shows at the end of the day.
Change 
> matdyn.x < q2r.in > q2r.out
> srun q2r.x < matdyn.in > matdyn.out
To
> srun q2r.x < q2r.in > q2r.out
> srun matdyn.x < matdyn.in > matdyn.out

## Errors

End of File error: **bto.dyn5** is empty...
Something gome wrong with DFPT, so let's wait 
assistant's answer.


# Run 4 an 5 data processing:

## Changes

Phonon calculations fully completed


## Errors:

matdyn.out:
>Error in routine find_bz_type (1):
>Wrong ibrav

# Run 6:

## Changes

Put appropriate q points in matdyn.in input for  
tetragonal structure symmetry, with a [suggested path][1]:
Γ—X—M—Γ—Z—R—A—Z|X—R|M—A 
[1]: https://beta.materialscloud.org/work/tools/seekpath#aboutWindow

>0.0  0.0  0.0 Γ
>0.0  0.0  0.5 X
>0.5  0.5  0.0 M
>0.0  0.0  0.0 Γ
>0.0  0.0  0.5 Z
>0.0  0.5  0.5 R
>0.5  0.5  0.5 A
>0.0  0.0  0.5 Z
>0.0  0.0  0.5 X
>0.0  0.5  0.5 R
>0.5  0.5  0.0 M
>0.5  0.5  0.5 A

## Errors

It worked out

# Run 7: 

## Changes:

Actual changes:

there are two separate paths now

* Γ—X—M—Γ—Z (path_1)
* X—R—Γ—A—M (path_2)

See [here][path]

[path]: https://satori.ims.uconn.edu/phonon-dispersion-batio3/