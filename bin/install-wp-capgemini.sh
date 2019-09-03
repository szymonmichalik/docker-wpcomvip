#!/usr/bin/env bash

# Install WordPress.
wp core multisite-install   --title=Capgemini   --admin_user=admin   --admin_password=admin   --admin_email=admin@example.com   --url=http://capgemini.local   --skip-email

# Update permalink structure.
wp option update permalink_structure /%year%/%monthnum%/%postname%/ --skip-themes --skip-plugins
