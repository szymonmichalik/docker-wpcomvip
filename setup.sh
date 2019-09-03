#!/bin/sh

# Set the variable for bash behavior
shopt -s nullglob
shopt -s dotglob

if [ ! -z "$(docker-compose ps | sed -e '/^\-\-\-/,$!d' -e '/^\-\-\-/d')" ]; then
  echo "Please run \`docker-compose down\` before running this script. (You will need"
  echo "to reimport content after this script completes.)"
  exit 1
fi

if [ ! -f .env ]; then
  echo "Config file does not exist. Nothing to do."
  exit 1
fi

source .env

# include helpers
. bin/helpers/render_template.sh
. bin/helpers/update_projects.sh


echo "Creating directories..."
echo ""

if [ -f docker-compose.yml ]; then
  echo "Recreating \`docker-compose.yml\`..."
  rm -f ./docker-compose.yml
fi
render_template ./templates/docker-compose.yml.tmpl > ./docker-compose.yml
chmod +x ./docker-compose.yml


if [ -f ./bin/wp-local-config.php ]; then
  echo "File \"wp-local-config.php\" exists, skipping."
else
  render_template ./templates/wp-local-config.php.tmpl > ./bin/wp-local-config.php
fi

if [ -f ./bin/install-wp.sh ]; then
    echo "File \"install-wp.sh\" exists, skipping."
else
  render_template ./templates/install-wp.sh.tmpl > ./bin/install-wp.sh
  chmod +x ./bin/install-wp.sh
fi

echo "Done."
echo ""

# Pull projects
echo "Updating ${PROJECT_TITLE} project..."
update_projects
echo "Done."
echo ""

# Done!
echo "Done! You are ready to run your Docker now."
echo ""
echo "To create project containers, run \`docker-compose up -d\`. If your container already exists, this will remove existing data."
echo "To start, run \`docker-compose start\`."
echo "To stop, run \`docker-compose stop\`."
echo "To prune, run \`docker system prune\`. Data will be lost."

echo ""
echo "To install WP Multisite network for every project, run \`docker-compose run --rm wp-cli install-wp\`"
