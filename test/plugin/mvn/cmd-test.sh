_do_plugin "mvn"

function test_full() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  {
    cd "$dir" &&
    echo '
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.example</groupId>
	<artifactId>demo</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>Demo</name>
	<packaging>pom</packaging>
</project>
' > "${dir}/pom.xml"
  } || _do_assert_fail

  _do_mvn 'fakerepo'

  # Test all base commands
  do-fakerepo-mvn-help || _do_assert_fail
  do-fakerepo-mvn-clean || _do_assert_fail
  do-fakerepo-mvn-build || _do_assert_fail
  do-fakerepo-mvn-test || _do_assert_fail
  do-fakerepo-mvn-install || _do_assert_fail
  do-fakerepo-mvn-verify || _do_assert_fail
  do-fakerepo-mvn-package || _do_assert_fail
  _do_alias_assert "do-fakerepo-mvn-deploy"
}
