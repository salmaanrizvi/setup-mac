function get_repo {
  echo "getting $1 repository.." 
  if [[ -d "$2" ]]; then
    echo "already have $2 repo.. pulling latest"
    cd "$2" && git checkout master && git pull origin master
  else
    git clone $1 $2
  fi
} 
