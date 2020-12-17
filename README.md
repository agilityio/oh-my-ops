[![Gitter](https://badges.gitter.im/oh-my-ops/community.svg)](https://gitter.im/oh-my-ops/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# DevOps
========

## Important

This repository will go open source on its own later.

## Get Started

To install this framework, runs:
curl -L https://raw.githubusercontent.com/agilityio/oh-my-ops/master/install.sh | bash

To get more support, please jump on [gitter](https://gitter.im/oh-my-ops/community).

## Prerequisites

* Bash 4+
* Git, Curl
* Docker
* MacOSX, Linux, or Windows (Cygwin)
* Docker

## Unit Testing

To test the whole framework run:

```
bash test.sh
```

To test just files in a specific directory, run:

```
bash test.sh test/plugin/git
```

To test just a single file, run:

```
bash test.sh test/plugin/git/repo-test.sh
```

To test just a function, run:

```
bash test.sh test/plugin/git/repo-test.sh#test_do_git_repo_add_status_commit
```
