Git-stage
=========
Git-stage lets the user compare the workspace with the stage area through a chosen diff tool. This way the user will be able to choose which modifications will be putted in the stage area, so the user has a fine control of what will be committed.

The script works by creating a temporary file to hold the file in it's staged form, and then compare the file in workspace with this temporary file. All modifications made on this temporary file, it will be putted back on the staged version of the file.

With `git-add` the user may choose which files will be committed, while with `git-stage` the user will be able to choose which part of a modified file will be committed.

Usage
-----
`git-stage.sh` must be run in the root of the git repository. Each file will be issued to the diff, on the left side will be workspace version of the file, and the right side is the staged version. Both sides may be modified. Since it will use the configured `diff.tool` to decide which diff command will be used, a diff tool must be configured through `git config diff.tool`.

Options
-------
 * `--three` Will issue a three way diff using the HEAD version of the file (the way the file was on the latest commit), the workspace version of the file and the staged version of the file.

Future work
===========
Improve the available options to make `git-stage` look more like the commands `git-diff` and `git-difftool`.
