source ./check_app.sh

## install functions take arguments in the form of
# $url, $app_name, [$existence_check_cmd]
function install_dmg {
  url="$1"
  app="$2"
  shift

  check_app $@
  if [[ $? -eq 0 ]]; then
    echo "$app already exists, skipping install"
    return 0
  fi

  local tempd=$(mktemp -d)
  curl -sL $url > $tempd/pkg.dmg
  listing=$(sudo hdiutil attach $tempd/pkg.dmg | grep Volumes)
  volume=$(echo "$listing" | cut -f 3)

  if [ -e "$volume"/*.app ]; then
    sudo cp -rf "$volume"/*.app /Applications
  elif [ -e "$volume"/*.pkg ]; then
    package=$(ls -1 "$volume" | grep .pkg | head -1)
    sudo installer -pkg "$volume"/"$package" -target /
  fi

  sudo hdiutil detach "$(echo "$listing" | cut -f 1 -d ' ')"
  rm -rf $tempd
}
