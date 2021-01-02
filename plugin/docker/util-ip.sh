function _do_docker_host_ip() {
  if _do_os_is_linux; then
    # See: https://che.eclipse.org/discovering-dockers-ip-address-2bb524b0cb28
    # https://github.com/eclipse/che/tree/master/dockerfiles/ip
    # Need to get the last line of the output to avoid first image pull output.
    local img="codenvy/che-ip"

    if ! _do_docker_util_image_exists "$img"; then
      echo "Downloading $img docker image for getting docker host ip."
      # Pull the image silently
      docker pull $img &>/dev/null
    fi

    docker run --net=host $img | tail -n1

  elif _do_os_is_mac; then
    # This impl works regardless of the order of wired & wireless network interfaces
    # https://apple.stackexchange.com/a/147777
    ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | head -n1
  fi

  # other OS is not supported yet
}
