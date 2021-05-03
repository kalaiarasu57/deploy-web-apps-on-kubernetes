# Use same image as runtime, to save space
FROM bitnami/php-fpm:8.0 AS builder
# Do not hardcode app version
ARG WORDPRESS_VERSION=5.7.1
# Install necessary packages for building/downloading the app
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates curl
RUN rm -r /var/lib/apt/lists /var/cache/apt/archives
# Install wp-cli
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod a+x /usr/local/bin/wp
# Download the application and reset ownership/permissions
# Verify that there are no files with extraneous permissions manually via command: find /wordpress/ -type d -not -perm 755 -o -type f -not -perm 644
RUN curl -s https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz | tar xz -C / --no-same-owner --no-same-permissions
# Ensure that the mounted volume can be written to
RUN chmod -R g+rwX /wordpress/wp-content
# Customize our web application
# WORKDIR /wordpress
# RUN curl http://.../plugin.zip | tar xz -C wp-content

# Use a minimal base image
FROM bitnami/php-fpm:8.0
# Install dependencies for wp-cli
RUN install_packages less
# Allow to configure WordPress via environment variables passed onto the PHP-FPM process
RUN sed -Ei 's/;(clear_env)/\1/' /opt/bitnami/php/etc/php-fpm.d/www.conf
# Install the application on the final image
COPY --from=builder /wordpress /wordpress
COPY --from=builder /usr/local/bin/wp /usr/local/bin/wp
# Install initialization scripts
COPY rootfs /
# Volume where to store app data files
RUN mkdir /wp-content && chmod g+rwX /wp-content
VOLUME [ "/wp-content" ]
# Run as a non-root user
USER 1001
# Define the default location where the app code will live
WORKDIR /wordpress
# Entrypoint will allow to decide whether to initialize the app
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "php-fpm", "-F" ]
# Default environment variable values, to deploy in development more conveniently
ENV ALLOW_EMPTY_PASSWORD="no" \
    WORDPRESS_DB_HOST="mariadb" \
    WORDPRESS_DB_NAME="wordpress" \
    WORDPRESS_DB_USER="wordpress" \
    WORDPRESS_DB_PASSWORD=""
