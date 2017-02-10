### OHBA utils

These utils crop up in several different places. It's a little unclear whether they should be in osl2/utils or here, but in general these contain helper functions that weren't originally in osl2 and are referred to by particular projects - e.g. `readnii` was provided by `GLEAN` but is a useful function to keep elsewhere.

Some files, notably `matrix2vols` and `vols2matrix` have been taken from `fmt`. As part of the longer-term plan to remove dependencies on FMT, FMT is not included on the Matlab path by default. Thus when errors are encountered, the preferred solution is to copy those functions into `ohba_utils`

##### Should my file go in my project, ohba_utils or osl2/utils?

- Does it require `osl` e.g. does it rely on `OSLDIR`? If so, put it in `osl2/utils`
- It it specific for a single project, and unlikely to be used elsewhere? If so, put it in your project folder
- Otherwise, put it in here

Thus this folder generally contains functions that are used by multiple OHBA projects and that do not require OSL