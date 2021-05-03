# Helm chart examples

## WordPress using Apache and mod_php

The [bitnami/wordpress](https://github.com/bitnami/charts/tree/master/bitnami/wordpress) Helm chart requires a container that contains the Apache service with mod_php, and the WordPress application installed.

Using the [WordPress with mod_php container image example](/1-container-image/examples/apache-with-modphp/full-wordpress-persistence/), you can deploy it with the Bitnami Helm chart like this:

```
$ helm install my-release --set image.repository=REPO --set image.tag=TAG bitnami/wordpress
```

> NOTE: You need to replace the *REPO* and *TAG* placeholders to your image. For instance, `marcosbc/wordpress-nginx` and `5.7.1` respectively.

## WordPress using NGINX and PHP-FPM

This is based on the previous [bitnami/wordpress](https://github.com/bitnami/charts/tree/master/bitnami/wordpress) Helm chart with a few modifications to support running both PHP-FPM and NGINX in the same pod, in a way so that they can communicate between them and serve the WordPress application to users.

Using the [WordPress with PHP-FPM container image example](/1-container-image/examples/nginx-with-php-fpm/full-wordpress-persistence/), you can deploy it with the WordPress+NGINX chart example like this, from this directory:

```
$ helm install my-release --set wordpressImage.repository=REPO --set wordpressImage.tag=TAG ./wordpress-nginx
```

> NOTE: You need to replace the *REPO* and *TAG* placeholders to your WordPress+PHP-FPM image. For instance, `marcosbc/wordpress-nginx` and `5.7.1` respectively. The NGINX container will use a `bitnami/nginx` container image by default, unless you override it with `nginxImage`.

### Notes

This charts relies on the full-persistence variant of the examples, to avoid the need to pre-install CDN support or require the need for populating WordPress data onto the NGINX container image.

Due to this, automatic upgrades are also expected to work out-of-the-box.

## Usage

To manage both WordPress installations in the charts, you can use the WP CLI which comes pre-installed:

```
$ /entrypoint.sh wp core install --url=http://localhost --admin_user=user --admin_password=bitnami --admin_email=user@example.com --title="My blog"
```

The `/entrypoint.sh` script will setup required environment variables for the WP CLI to work properly, like the path to the WordPress installation and so, so it can be run outside of the WordPress installation directory.
