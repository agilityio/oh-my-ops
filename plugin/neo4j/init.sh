_do_plugin 'docker'
_do_plugin 'repo'

_do_log_level_warn 'neo4j'
_do_src_include_others_same_dir

# Initializes neo4j plugin.
#
function _do_neo4j_plugin_init() {
  _do_log_info 'neo4j' 'Initialize plugin'

  # This is the default neo4j version to run with.
  _DO_NEO4J_VERSION=${_DO_NEO4J_VERSION:-latest}

  # This is the default neo4j port.
  _DO_NEO4J_HTTP_PORT=${_DO_NEO4J_HTTP_PORT:-7474}
  _DO_NEO4J_HTTPS_PORT=${_DO_NEO4J_HTTPS_PORT:-7473}
  _DO_NEO4J_BOLT_PORT=${_DO_NEO4J_BOLT_PORT:-7687}

  # This is the default database created, and credential to access it.
  _DO_NEO4J_USER=${_DO_NEO4J_USER:-neo4j}
  _DO_NEO4J_PASS=${_DO_NEO4J_PASS:-pass}
}
