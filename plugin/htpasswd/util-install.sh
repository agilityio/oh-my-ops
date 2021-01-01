function _do_htpasswd_util_install() {
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  echo "
FROM alpine:3.12

RUN echo 'Installing base packages' \
	&& apk add --update --no-cache \
		apache2-utils \
	&& echo 'Removing apk cache' \
	&& rm -rf /var/cache/apk/

ENTRYPOINT [\"htpasswd\"]
" >"${tmp_dir}/Dockerfile"

  # Builds the docker image
  _do_docker_container_build "${tmp_dir}" "${_DO_HTPASSWD_DOCKER_IMAGE}" || return 1
}

function _do_htpasswd_util_exists() {
  _do_docker_image_exists "${_DO_HTPASSWD_DOCKER_IMAGE}" || return 1
}

function _do_htpasswd_util_install_if_missing() {
  _do_htpasswd_util_exists ||
    _do_htpasswd_util_install ||
    return 1
}
