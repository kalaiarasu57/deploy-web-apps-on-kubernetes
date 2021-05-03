# Use same image as runtime, to save space
FROM bitnami/minideb:buster AS builder
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
# Customize our web application
# WORKDIR /wordpress
# RUN curl http://.../plugin.zip | tar xz -C wp-content

# Use a minimal base image
FROM bitnami/minideb:buster
# Install dependencies
RUN install_packages \
    # Server stack
    apache2 \
    libapache2-mod-php7.3 \
    php7.3-mysql \
    # Dependencies for wp-cli
    less \
    curl
# Install the application on the final image
COPY --from=builder /wordpress /opt/wordpress-src
COPY --from=builder /usr/local/bin/wp /usr/local/bin/wp
# Volume where to store app data files
RUN mkdir /wordpress && chmod g+rwX /wordpress
VOLUME [ "/wordpress" ]
# Install initialization scripts
COPY rootfs /
# Prepare Apache to run WordPress in in a non-root environment
RUN chown -R root:root /var/log/apache2 /var/run/apache2 && \
    chmod -R g+rwX /var/log/apache2 /var/run/apache2 && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log && \
    a2dissite 000-default && \
    a2ensite wordpress
# Run as a non-root user
USER 1001
# Define the default location where the app code will live
WORKDIR /wordpress
# Entrypoint will allow to decide whether to initialize the app
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "apachectl", "-DFOREGROUND" ]
# Default environment variable values, to deploy in development more conveniently
ENV ALLOW_EMPTY_PASSWORD="no" \
    WORDPRESS_DB_HOST="mariadb" \
    WORDPRESS_DB_NAME="wordpress" \
    WORDPRESS_DB_USER="wordpress" \
    WORDPRESS_DB_PASSWORD=""
