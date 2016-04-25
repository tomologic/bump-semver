#!/bin/bash
# Bumps the semantic version of the git-project.
# If no semantic version tags exists in the project, the version starts out at v0.0.0
# and is incremented by one for the field indicated by the bump command argument.

find_latest_semver() {
  pattern="^$PREFIX([0-9]+\.[0-9]+\.[0-9]+)\$"
  versions=$(for tag in $(git tag); do
    [[ "$tag" =~ $pattern ]] && echo "${BASH_REMATCH[1]}"
  done)
  if [ -z "$versions" ];then
    echo 0.0.0
  else
    echo "$versions" | tr '.' ' ' | sort -nr -k 1 -k 2 -k 3 | tr ' ' '.' | head -1
  fi
}

increment_ver() {
  find_latest_semver | awk -F. -v a="$1" -v b="$2" -v c="$3" \
      '{printf("%d.%d.%d", $1+a, $2+b , $3+c)}'
}

bump() {
  next_ver="${PREFIX}$(increment_ver "$1" "$2" "$3")"
  latest_ver="${PREFIX}$(find_latest_semver)"
  latest_commit=$(git rev-parse "${latest_ver}" 2>/dev/null )
  head_commit=$(git rev-parse HEAD)
  if [ "$latest_commit" = "$head_commit" ]; then
      echo "refusing to tag; $latest_ver already tagged for HEAD ($head_commit)"
  else
      echo "tagging $next_ver $head_commit"
      git tag "$next_ver" HEAD
  fi
}

usage() {
  echo "Usage: bump [-p prefix] major|minor|patch"
  echo "Bumps the semantic version field by one for a git-project."
  exit 1
}

while getopts ":p:" opt; do
  case $opt in
    p) PREFIX="$OPTARG";;
    \?) echo "invalid option -$OPTARG"; exit 1;;
    :) echo "option -$OPTARG requires an argument"; exit 1;;
  esac
  shift $((OPTIND-1))
done

case $1 in
  major) bump 1 0 0;;
  minor) bump 0 1 0;;
  patch) bump 0 0 1;;
  *) usage
esac
