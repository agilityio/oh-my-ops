_do_plugin "yaml"

function test_parse() {
  local dir="$(_do_src_dir)"

  # Counts the result and make sure there is more than one line
  local count=$(_do_yaml_parse "${dir}/data-1.yml" | grep "SampleProject_" | wc -l)
  [ ${count} -gt 0 ] || _do_assert_fail

  # Counts the result and make sure there is more than one line
  count=$(_do_yaml_parse "${dir}/data-1.yml" "S_" | grep "SampleProject_" | wc -l)
  [ ${count} -gt 0 ] || _do_assert_fail
}

function test_export_uppercase_var() {
  local dir="$(_do_src_dir)"

  _do_yaml_export_uppercase_var "${dir}/data-1.yml"

  # Counts the result and make sure there is more than one line
  local count=$(declare -p | grep SAMPLEPROJECT | wc -l)
  [ ${count} -gt 0 ] || _do_assert_fail

  _do_yaml_export_uppercase_var "${dir}/data-1.yml" "S_"

  # Counts the result and make sure there is more than one line
  local count=$(declare -p | grep S_SAMPLEPROJECT | wc -l)
  [ ${count} -gt 0 ] || _do_assert_fail

}

function test_export_lowercase_var() {
  local dir="$(_do_src_dir)"

  _do_yaml_export_lowercase_var "${dir}/data-1.yml"

  # Counts the result and make sure there is more than one line
  local count=$(declare -p | grep sampleproject | wc -l)
  [ ${count} -gt 0 ] || _do_assert_fail

  _do_yaml_export_lowercase_var "${dir}/data-1.yml" "s_"

  # Counts the result and make sure there is more than one line
  local count=$(declare -p | grep s_sampleproject | wc -l)
  [ ${count} -gt 0 ] || _do_assert_fail

}
