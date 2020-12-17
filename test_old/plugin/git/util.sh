_do_plugin "proj"
_do_plugin "git"

_do_log_level_warn "plugin"
_do_log_level_warn "repo"

proj_dir="./proj"
fake_repo="fake-repo"

# Creates a new project.
rm -rfd "${proj_dir}"
mkdir -p "${proj_dir}"

# Makes a fake "do" repository that will serves as the default
# repository for the project. This repository will have some
# git remote, which will be copy over to any new repository generated.
#
fake_do_dir="${proj_dir}/do"
mkdir -p "${fake_do_dir}"
_do_dir_push "${fake_do_dir}"
git init .
git remote add "fakeremote" "git@fakedomain.com:agilityio/oh-my-ops.git"
_do_dir_pop

# Initializes the project with the specified default "do" repository
# generated previously.
_do_proj_init "${proj_dir}" "do"
