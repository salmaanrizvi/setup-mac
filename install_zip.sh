source ./check_app.sh

## install functions take arguments in the form of
# $url, $app_name, [$existence_check_cmd]
function install_zip {
  url="$1"
  app="$2"
  shift

  check_app $@
  if [[ $? -eq 0 ]]; then
    echo "$app already exists, skipping install.."
    return 0
  fi

  local tempd=$(mktemp -d)
  curl -sL $url > $tempd/pkg.zip
  sudo unzip -qqa "$tempd/pkg.zip" -d "$tempd"
  app=$(find "$tempd" -name "*.app" -d 1)

  if [ -n "$app" ]; then
    sudo cp -rf "$app" /Applications
    sudo rm -rf $tempd
  else
    echo "no .app file found in pkg at $tempd ... leaving"  
  fi
}
