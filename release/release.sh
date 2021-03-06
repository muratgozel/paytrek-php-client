#!/bin/bash

echo "👨‍🔧 releasing app..."
# measure script execution time
start_time=$(date +%s)

# validate
if [ -z "$1" ]; then
  echo "👨‍🔧 is it major, minor or patch?"
  exit 1
fi
if [ -z "$2" ]; then
  echo "👨‍🔧 you must add a commit message as an argument."
  exit 1
fi

# check if there are changes
changes=$(node ./release/checkChanges.js)

if [[ $changes == "yes" ]]; then
  # generate the next release tag
  next=$(node ./release/getNextReleaseNum.js $1)

  # push
  echo "Releasing new version (${next})..."
  git tag -a "$next" -m "$2"
  git add .
  git commit -m "$2"
  git push origin master
else
  echo "👨🏻‍💻 no changes detected in the codebase. nothing to push."
  exit 1
fi

echo "👨‍🔧 successfully released. ( $((($(date +%s)-$start_time)/60)) minutes. )"
