## check app takes arguments in the form of
# $app_name, [$custom_existence_check]
function check_app {
  echo "check app called with $# args: $@"
  # custom check provided
  if [[ "$#" -ge 2 ]]; then
    shift
    echo "calling $@"
    "$@" &> /dev/null
  else # fallback to default
    ls /Applications/ | grep "$1" &> /dev/null
  fi

  if [[ $? -eq 0 ]]; then
    return 0
  fi

  return 1
}
