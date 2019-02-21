# DevOps
========


Get Started
===========




Unit Testing
============

To test the whole framework run:

```
do_test
```

To test just files in a specific directory, run:

```
do_test test/plugin/git
```

To test just a single file, run:

```
do_test test/plugin/git/repo-test.sh
```

To test just a function, run:

```
do_test test/plugin/git/repo-test.sh#test_do_git_repo_add_status_commit
```
