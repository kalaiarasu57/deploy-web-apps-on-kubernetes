# Container image examples

We have created examples using the two most popular web servers around, Apache and NGINX. Each example comes in two variants:

* Full persistence: The entire WordPress `htdocs` folder is persisted. This allows for automatic upgrade support via the app's admin panel.
* Only wp-content persistence: Only data files, included in `wp-content`, are persisted. This allows for upgrading the application by changing the container image tag.

You can find each of them in a specific sub-folder. In both cases, the container images are designed with multi-stage so that only the essential dependencies are installed at runtime, and keeping the container image size minimal.

## WordPress using Apache and mod_php

This is using a Debian base image with Apache, PHP 7.2 and mod_php installed on top of it.

With mod_php, the Apache server is able to process PHP scripts and serve them as if they were a file (like .html or .css), without the need for any external server. And non-PHP files are served like usual.

> NOTE: It is not using Bitnami folders so that you can see there is not really a big difference. You can find a WordPress container image following Bitnami's standards [here](https://github.com/bitnami/bitnami-docker-wordpress).

## WordPress using NGINX and PHP-FPM

This examples includes a container with PHP-FPM and the WordPress application, which is proxied via the NGINX web server, running in a separate container.

> NOTE: It is possible for the NGINX server to serve a PHP-FPM container without including any WordPress-specific file (like themes resources). However this requires a CDN to be pre-configured, for files to exist in the NGINX container's root. If not, NGINX will not be able to serve these files. In the wp-content persistence variant, you can see the second approach being followed, with a NGINX container image being created only to contain specific WordPress asset files.
