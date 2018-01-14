# Folder Purpose

Do quickly the whole phonon calculations 
in order to quickly debug and troubleshoot everything,
before passing to higher ecutwfc (100) and ecutrho (800),
also before passing to higher q points in phonon calculation.


# Phonon q point paths

## Actual Path taken:

* Γ—X—M—Γ—Z (path_1)
* X—R—Γ—A—M (path_2)

See [here][path]

[path]: https://satori.ims.uconn.edu/phonon-dispersion-batio3/

## tP1 [with inversion]

This is the suggested path from [materialscloud][matcloud]

Γ—X—M—Γ—Z—R—A—Z|X—R|M—A

Γ     0.0     0.0     0.0
X     0.0     1/2     0.0
M     1/2     1/2     0.0
Γ     0.0     0.0     0.0
Z     0.0     0.0     1/2
R     0.0     1/2     1/2
A     1/2     1/2     1/2
Z     0.0     0.0     1/2
X     0.0     1/2     0.0
R     0.0     1/2     1/2
M     1/2     1/2     0.0
A     1/2     1/2     1/2

## tp1 [no inversion]

This is the suggested path from [materialscloud][matcloud]

Γ—X—M—Γ—Z—R—A—Z|X—R|M—A|Γ—X'—M'—Γ—Z'—R'—A'—Z'|X'—R'|M'—A'

Γ      0.0      0.0     0.0
X      0.0      1/2     0.0
M      1/2      1/2     0.0
Γ      0.0      0.0     0.0
Z      0.0      0.0     1/2
R      0.0      1/2     1/2
A      1/2      1/2     1/2
Z      0.0      0.0     1/2
X      0.0      1/2     0.0
R      0.0      1/2     1/2
M      1/2      1/2     0.0
A      1/2      1/2     1/2
Γ      0.0      0.0     0.0
X'     0.0     -1/2     0.0
M'    -1/2     -1/2    -0.0
Γ      0.0      0.0     0.0
Z'     0.0      0.0    -1/2
R'     0.0     -1/2    -1/2
A'    -1/2     -1/2    -1/2
Z'     0.0      0.0    -1/2
X'     0.0     -1/2     0.0
R'     0.0     -1/2    -1/2
M'    -1/2     -1/2    -0.0
A'    -1/2     -1/2    -1/2


[matcloud][https://beta.materialscloud.org/work/tools/seekpath#aboutWindow]
