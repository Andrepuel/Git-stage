#!/bin/bash

# Initial checking ------------------------------------------------------------------
if [ ! -e .git ]; then
	echo "Not in then root of a git repository" 1>&2
	exit 1
fi
git config diff.tool >/dev/null
if [ $? -gt 0 ]; then
	echo "Please set a diff tool using git config diff.tool command" 1>&2
	exit 1
fi
differ=`git config diff.tool`
git config difftool.$differ.cmd > /dev/null
if [ $? -gt 0 ]; then
    differ="$differ \$LOCAL \$REMOTE"
else
    differ="`git config difftool.$differ.cmd`"
fi
LOCAL=local
REMOTE=remote
function getDiffer {
    echo "Do you want to diff $LOCAL and $REMOTE? [y/n]" >&2
    read answer
    if [ "$answer"es = 'yes' -o "$answer"es == 'es' ]; then
        echo $differ | sed 's,$LOCAL,"'$LOCAL'",g' | sed 's,$REMOTE,"'$REMOTE'",g'
    else
        echo echo
    fi
}

# Options ---------------------------------------------------------------------------

three_way_diff=
for var in "$@"; do
	if [ $var == "--three" ]; then
		three_way_diff=true
	fi
done

# Diffing each file -----------------------------------------------------------------

IFS='
'
for eachFile in `git status --short | cut -c 4-`; do
	if [ -d $eachFile ]; then
		echo "Directory is not supported yet, ignoring $eachFile" 1>&2
		continue
	fi
	repoFile=`mktemp /tmp/XXXXX`
	stageFile=`mktemp /tmp/XXXXX`

	if [ `echo $eachFile | cut -c 1` == '"' ]; then
		eachFile=$(echo $eachFile | cut -c 2-$(($(echo $eachFile | wc -c)-2)))
	fi

	touch $repoFile
	git show "HEAD:$eachFile" > $repoFile 
	cp $repoFile $stageFile
	git diff --staged "$eachFile" | patch -f $stageFile

	if [ $three_way_diff ]; then
        LOCAL=$repoFile
        REMOTE="$eachFile"
        echo `getDiffer` $stageFile | /bin/bash
	else
        LOCAL="$eachFile"
        REMOTE=$stageFile
        echo `getDiffer` | /bin/bash
	fi

	if [ `diff $repoFile $stageFile | wc -l` -eq 0 ]; then
		git reset HEAD "$eachFile" 2>/dev/null
	else
		cp "$eachFile" $repoFile
		cp $stageFile "$eachFile"
		git add "$eachFile"
		cp $repoFile "$eachFile"
	fi

	rm $repoFile
	rm $stageFile
done
