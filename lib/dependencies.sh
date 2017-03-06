install_oracle_libraries(){
  echo $HOME
  local build_dir=${1:-}
  echo "Installing oracle libraries"
  mkdir -p $build_dir/oracle
  cd $build_dir/oracle
  local basic_download_url="https://github.com/karthikeyabhaghavatula/instantclient-basic-linux-12.1/archive/master.zip"
  curl -LOk "$basic_download_url" --silent --fail --retry 5 --retry-max-time 15 -o instantclient-basic.zip
  echo "Downloaded [$basic_download_url]"
  echo "unzipping libraries"
  unzip master.zip
  cd instantclient-basic-linux-12.1-master
  unzip instantclient-basic-linux.x64-12.1.0.2.0.zip
  unzip instantclient-sdk-linux.x64-12.1.0.2.0.zip
  mv instantclient_12_1 instantclient
  cd instantclient
  ln -s libclntsh.so.12.1 libclntsh.so
}

install_node_modules() {
  local build_dir=${1:-}

  if [ -e $build_dir/package.json ]; then
    cd $build_dir

    if [ -e $build_dir/npm-shrinkwrap.json ]; then
      echo "Installing node modules (package.json + shrinkwrap)"
    else
      echo "Installing node modules (package.json)"
    fi
    npm install --unsafe-perm --userconfig $build_dir/.npmrc 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}

rebuild_node_modules() {
  local build_dir=${1:-}

  if [ -e $build_dir/package.json ]; then
    cd $build_dir
    echo "Rebuilding any native modules"
    npm rebuild --nodedir=$build_dir/.heroku/node 2>&1
    if [ -e $build_dir/npm-shrinkwrap.json ]; then
      echo "Installing any new modules (package.json + shrinkwrap)"
    else
      echo "Installing any new modules (package.json)"
    fi
    npm install --unsafe-perm --userconfig $build_dir/.npmrc 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}
