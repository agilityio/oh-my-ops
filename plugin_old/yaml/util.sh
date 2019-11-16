# Parse YAML file
#
# Arguments:
#  1. file: Required. YAML filepath to read content
#  2. prefix: Optional. The prefix of assigning variable (e.g: "credential_")
#  3. convert: Optional. The awk convert function (e.g., toupper, tolower)
#
# Credits:
#   - https://github.com/jasperes/bash-yaml
#
function _do_yaml_parse() {
  local file=${1?'file arg required'}
  local prefix=${2:-}
  local convert=${3:-}

  if [ -z "convert" ]; then
    convert='$2'
  else
    convert="${convert}"'($2)'
  fi

  local s
  local w
  local fs

  s='[[:space:]]*'
  w='[a-zA-Z0-9_.-]*'
  fs="$(echo @ | tr @ '\034')"

  (
    sed -ne '/^--/s|--||g; s|\"|\\\"|g; s/\s*$//g;' \
      -e "/#.*[\"\']/!s| #.*||g; /^#/s|#.*||g;" \
      -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" |
      awk -F"$fs" '{
            indent = length($1)/2;
            if (length($2) == 0) { conj[indent]="+";} else {conj[indent]="";}
            vname[indent] = '${convert}';
            for (i in vname) {if (i > indent) {delete vname[i]}}
                if (length($3) > 0) {
                    vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                    printf("%s%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, '${convert}', conj[indent-1],$3);
                }
            }' |
      sed -e 's/_=/+=/g' \
        -e '/\..*=/s|\.|_|' \
        -e '/\-.*=/s|\-|_|'

  ) <"${file}"
}

function _do_yaml_export_uppercase_var() {
  local file="$1"
  local prefix="$2"

  eval "$(_do_yaml_parse ${file} "${prefix}" 'toupper')"
}

function _do_yaml_export_lowercase_var() {
  local file="$1"
  local prefix="$2"

  eval "$(_do_yaml_parse ${file} "${prefix}" 'tolower')"
}
