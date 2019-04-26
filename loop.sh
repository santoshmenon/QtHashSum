#!/bin/bash
set -euxo pipefail

if [ $# -lt 3 ]; then
	echo "Usage: loop.sh WatchDir OutFile"
	exit 1
fi

WatchDir=$1
OutFile=$2

if [ ! -d "$WatchDir" ]; then
	echo "$WatchDir directory doesn't exist"
	exit 1
fi

WatchDir=(cd "$WatchDir"; pwd) # realpath, readlink -f

[ -f "$OutFile" ] && touch "$OutFile"

GitRepo=$(dirname "$OutFile")
IsGitRepo=$(git -C "$GitRepo" rev-parse --is-inside-work-tree > /dev/null 2>&1)

if [ "$IsGitRepo" ]; then
	echo "inside git repo"
else
	echo "not in git repo"
fi

while :
do
	docker run --rm -i -v "$WatchDir":/data fffaraz/qthashsum . > "$OutFile"
	date
	sleep 3600
done
