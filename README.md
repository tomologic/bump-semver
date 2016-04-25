# bump-semver
A script for bumping the individual semantic version fields.

It looks for semantic version tags in the current git project and tags HEAD with the next incremental semantic version number. The semantic field that gets incremented is controlled by an argument to the script.

If HEAD is already tagged with a semantic version, the script will cowardly refuse to tag and let you know what version is already tagged for the HEAD commit.

## Usage
```
Usage: bump [-p prefix] {major|minor|patch} | -l
Bumps the semantic version field by one for a git-project.

Options:
  -l  list the latest tagged version instead of bumping.
  -p  prefix [to be] used for the semver tags.
```

## Examples
### bumping
Given a git project with the highest semantic version tag being `0.0.0`, or where no semantic version exists at all, the following three invocations will yield a new tag with the specified version number:

* `bump.sh major` -> 1.0.0
* `bump.sh minor` -> 0.1.0
* `bump.sh patch` -> 0.0.1

For a project that uses a _v_-prefix, the optional _prefix_ option can be used.

`bump.sh -p v minor` -> v0.1.0

When prefix is used, only semantic version tags with that prefix will be considered during bumping.
### listing
List the highest semantic version following strict semver (n.n.n): `bump.sh -l`  
Same but when using prefixed semver ([prefix]n.n.n), in this case with prefix _v_: `bump.sh -p v -l`
