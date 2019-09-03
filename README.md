# WPCOM VIP Go development for Docker

#### Based on: [chriszarate/docker-wordpress-vip-go](https://github.com/chriszarate/docker-wordpress-vip-go).

This repo provides a Docker-based environment for [WordPress VIP Go][vip-go]
development. It provides WordPress, MariaDB, and WP-CLI. It
further adds VIP Go mu-plugins and a [Photon][photon] server to closely mimic a
VIP Go environment.

## Set up

1. Clone [this or fork this repo](https://github.com/szymonmichalik/nginx-proxy) and follow instructions. It is required to build an external network for proxy, so you can simultaneously run multiple VIP Go projects on your local environment

2. Copy `sample.env` to `.env` and provide your project title, domain name (same as in step 1), database port (unique for every instance of this repo), and GitHub repo, which contains your VIP Go ready project.

3. Run `./setup.sh`.

4. Run `docker-compose up -d`.

## Install WordPress

```sh
docker-compose run --rm wp-cli install-wp
```

Log in to `http://project.local/wp-admin/` with `admin@example.com` / `admin`.

## WP-CLI

You will probably want to create a shell alias for this:

```sh
docker-compose run --rm wp-cli wp [command]
```

## Photon

A [Photon][photon] server is included and enabled by default to more closely
mimic the WordPress VIP production environment. Requests to `/wp-content/uploads`
will be proxied to the Photon container—simply append Photon-compatible query
string parameters to the URL.

## Troubleshooting

If your stack is not responding, the most likely cause is that a container has
stopped or failed to start. Check to see if all of the containers are "Up":

```
docker-compose ps
```

If not, inspect the logs for that container, e.g.:

```
docker-compose logs wordpress
```

Running `./bin/helpers/update_projects.sh` again can also help resolve problems.

[vip-go]: https://vip.wordpress.com/documentation/vip-go/
[photon]: https://jetpack.com/support/photon/
[image]: https://hub.docker.com/r/chriszarate/wordpress/
