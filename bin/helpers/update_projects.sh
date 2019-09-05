#!/bin/sh
function update_projects() {

  if [ ! -f docker-compose.yml ]; then
    echo "Please run this script from the root of the repo."
    exit 1
  fi

  echo "Updating repository...."
  git fetch && git pull origin master && echo ""

  # Make sure projects directory exists.
  mkdir -p source

  # Make sure uploads directory exists.
  mkdir -p source/uploads

  # Clone git repos.
  for repo in \
    ${PROJECT_REPO} \
    Automattic/vip-go-mu-plugins \
    tollmanz/wordpress-pecl-memcached-object-cache
  do
    dir_name="${repo##*/}"
    if [ "$repo" == "${PROJECT_REPO}" ]; then
      dir_name="content"
    fi

    # Clone repo if it is not in the "source" subfolder.
    if [ ! -d "source/$dir_name/.git" ]; then
      echo "Cloning $repo into \"source\" subfolder...."
      rm -rf source/$dir_name
      git clone --recursive git@github.com:$repo "source/$dir_name"
    fi

    # Make sure repos are up-to-date.
    echo "Updating $repo...."
    pushd source/$dir_name >/dev/null && \
      git pull origin master --ff-only && \
      git submodule update && \
      popd >/dev/null && \
      echo ""
  done

}
