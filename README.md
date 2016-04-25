# bump-semver
A script for bumping the individual semantic version fields.

It looks for semantic version tags in the current git project and tags HEAD with the next incremental semantic version number. The semantic field that get incremented by is controlled by an argument to the script.

If HEAD is already tagged with a semantic version, the script will cowardly refuse to tag and let you know what semantic version is already tagged for the HEAD commit.

## Usage
```
Usage: bump [-p prefix] major|minor|patch
Bumps the semantic version field by one for a git-project.
```

## Example
Given a git project with the highest semantic version tag being `0.0.0`, or where no semantic version exists at all, the following three invocations will yield a new tag with the specified version number:

* `bump.sh major` -> 1.0.0
* `bump.sh minor` -> 0.1.0
* `bump.sh patch` -> 0.0.1

For a project that uses a _v_-prefix, the optional _prefix_ option can be used.

`./bump.sh -p v minor` -> v0.1.0

When prefix is used, only semantic version tags with that prefix will be considered during bumping.