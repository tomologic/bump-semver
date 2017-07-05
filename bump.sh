#!/bin/bash
#
# The MIT License
#
# Copyright (c) 2016-2017 Tomologic AB
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Bumps the semantic version of the git-project.
# If no semantic version tags exist in the project, the version starts out at v0.0.0
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
      git tag "$next_ver" $head_commit
  fi
}

usage() {
  echo "Usage: bump [-p prefix] {major|minor|patch} | -l"
  echo "Bumps the semantic version field by one for a git-project."
  echo
  echo "Options:"
  echo "  -l  list the latest tagged version instead of bumping."
  echo "  -p  prefix [to be] used for the semver tags."
  exit 1
}

while getopts :p:l opt; do
  case $opt in
    p) PREFIX="$OPTARG";;
    l) LIST=1;;
    \?) usage;;
    :) echo "option -$OPTARG requires an argument"; exit 1;;
  esac
done
shift $((OPTIND-1))

if [ ! -z "$LIST" ];then
  find_latest_semver
  exit 0
fi

case $1 in
  major) bump 1 0 0;;
  minor) bump 0 1 0;;
  patch) bump 0 0 1;;
  *) usage
esac
