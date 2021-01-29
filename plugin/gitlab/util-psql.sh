function _do_gitlab_util_psql() {
  local repo=${1?'repo arg required'}
  local sql=${2?'sql arg required'}
  local container
  container=$(_do_gitlab_docker_container_name "${repo}") || return 1

  # Executes the embedded psql cli with the specified sql statement.
  docker exec -it --user gitlab-psql  \
    "${container}" \
    /opt/gitlab/embedded/bin/psql  \
    --port 5432 \
    -h /var/opt/gitlab/postgresql \
    -d gitlabhq_production \
    -c "${sql}" &> /dev/null || return 1
}

function _do_gitlab_util_psql_create_application() {
  local repo=${1?'repo arg required'}
  local name=${2?'name arg required'}
  local client_id=${3?'client_id arg required'}
  local client_secret=${4?'client_secret arg required'}
  local redirect_uri=${5?'redirect_uri arg required'}
  local scopes=${6?'scopes arg required'}

      _do_gitlab_util_psql "${repo}" "
DELETE FROM oauth_applications
WHERE uid='${client_id}';

INSERT INTO oauth_applications (
    name,
    uid,
    secret,
    trusted,
    confidential,
    redirect_uri,
    scopes,
    created_at,
    updated_at
) VALUES (
    '${name}',
    '${client_id}',
    '${client_secret}',
    TRUE,
    FALSE,
    '${redirect_uri}',
    '${scopes}',
    '2020-12-27 13:56:09.313904',
    '2020-12-27 13:56:09.313904'
);
" &> /dev/null || return 1
}
