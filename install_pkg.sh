source ./check_app.sh

## install functions take arguments in the form of
# $url, $app_name, [$existence_check_cmd]
function install_pkg {
  url="$1"
  app="$2"
  shift

  check_app $@
  if [[ $? -eq 0 ]]; then
    echo "$app already exists, skipping install.."
    return 0
  fi

  local tempd=$(mktemp -d)
  curl -sL $url > $tempd/package.pkg
  sudo installer -pkg $tempd/package.pkg -target /
  sudo rm -rf $tempd/package.pkg 
}
