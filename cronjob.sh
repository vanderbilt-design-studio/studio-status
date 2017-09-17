#!/bin/sh

UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "studio_status up to date"
elif [ $LOCAL = $BASE ]; then
    echo "studio_status updating..."
    git pull
    kill `pgrep -f processing-java`
    processing-java --sketch=`pwd` --run &
elif [ $REMOTE = $BASE ]; then
    echo 'Origin is behind, huh?'
else
    echo 'Diverged!'
fi


