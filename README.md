Git-stage
=========
Git-stage is a command line script that runs a modifiable diff between the current workspace and the staged changes. Modifiable means that the changes made in the right side (stage) will be persisted to the git stage area.

Usage
-----
First a diff tool must be configured through `git config diff.tool`.

`git-stage.sh` must be run in the root of the git repository. Each file will be issued to the diff, on the left side will be workspace file, and the right side is the changes that are on the stage. Both sides may be modified.

Options
-------
 * `--three` Will issue a three way diff. On the left will be the file on HEAD (not modified), in the middle is the file in the workspace, and in the right is the file in the stage area.
