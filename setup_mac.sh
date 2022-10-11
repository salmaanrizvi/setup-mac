# !/bin/bash

set -u
source ./check_app.sh
source ./get_repo.sh
source ./install_dmg.sh
source ./install_pkg.sh
source ./install_zip.sh

function validate_input {
  local confirm 
  read -p "Continue? (y/n): " confirm

  status="1" 
  if [[ "$confirm" == [yY] || "$confirm" == [yY][eE][sS] ]]; then 
    status="0"
  fi

  echo "$status"
}

## validate shell is bash
echo "checking default shell"
if [[ "$SHELL" != ["/bin/bash"] ]]; then
  chsh -s /bin/bash
  echo "set bash as default shell"
else
  echo "default shell is already set to bash" 
fi

## setup git
echo "checking git"
git > /dev/null

## generate ssh key for this computer if necessary
echo "check GitHub ssh status"
ssh -T git@github.com > /dev/null

if [[ $? -ne 1 ]]; then
  echo "No valid GitHub ssh key found. Attempting to generate"

  if [[ $(validate_input) == "0" ]]; then
    echo "generating ssh key.."
    read -p "enter GitHub username: " gh_user

    ssh-keygen -t rsa -b 4096 -C "$gh_user"
    eval "$(ssh-agent -s)"
    ssh-add -K ~/.ssh/id_rsa
    id_rsa=$(cat ~/.ssh/id_rsa.pub)

    read -p "enter GitHub PAT: " gh_pat
    read -p "enter key name: " ssh_key_name

    curl -u "$gh_user:$gh_pat" --data "{\"title\":\"$ssh_key_name\",\"key\":\"$id_rsa\"}" https://api.github.com/user/keys
  else
    echo "skipping generating GitHub ssh keys"
  fi
fi

# get relevant git repos
mkdir ~/git

echo "cloning bash_profile"
get_repo git@github.com:salmaanrizvi/bash_profile.git ~/git/bash_profile

echo "symlinking bash_profile(s)" 
ln -is ~/git/bash_profile/.profile ~/.doordash_profile
ln -is ~/git/bash_profile/.profile ~/.profile
ln -is ~/git/bash_profile/.bash_profile ~/.bash_profile

## install iterm2
echo "installing iTerm 2"
install_zip https://iterm2.com/downloads/stable/iTerm2-3_4_16.zip "iTerm"
if [[ $? -eq 0 ]]; then
  echo "done installing iTerm. install iterm settings?"
  if [[ $(validate_input) == "0" ]]; then
    get_repo git@github.com:salmaanrizvi/iTermSettings.git ~/git/iTermSettings
    echo "please import preferences in General -> Preferences -> Load Preferences. waiting..."
    open -Wn /Applications/iTerm.app
  fi
fi

echo "installing Sublime"
install_dmg "https://download.sublimetext.com/Sublime%20Text%20Build%203211.dmg" "Sublime"
if [[ $? -eq 0 ]]; then
  echo "done installing sublime. install sublime settings?"
  if [[ $(validate_input) == "0" ]]; then
    get_repo git@github.com:salmaanrizvi/SublimeSettings.git ~/git/SublimeSettings
    sudo ln -is /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
    echo "please install package control. waiting..."
    open -Wn /Applications/Sublime\ Text.app
    ln -is ~/git/SublimeSettings/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
  fi
fi

echo "installing Rectangle"
install_dmg "https://github.com/rxhanson/Rectangle/releases/download/v0.59/Rectangle0.59.dmg" "Rectangle"

echo "installing Alfred"
install_dmg "https://cachefly.alfredapp.com/Alfred_5.0.3_2087.dmg" "Alfred"

echo "installing Firefox"
install_dmg "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US" "Firefox"

echo "installing 1Password"
install_zip "https://downloads.1password.com/mac/1Password.zip" "1Password 8"

echo "installing Slack"
install_dmg "https://slack.com/ssb/download-osx" "Slack"

echo "installing Docker"
install_dmg "https://desktop.docker.com/mac/main/arm64/Docker.dmg" "Docker"

echo "installing Go"
install_pkg "https://dl.google.com/go/go1.14.2.darwin-amd64.pkg" "Go" "ls /usr/local/go"

which brew
if [[ $? -ne 0 ]]; then
  echo "installing brew"
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew install ripgrep tig node fzf bat hub kubectl helm jq kubectx tfenv fd bash-completion

source ~/.bash_profile
