# Use same image as runtime, to save space
FROM bitnami/nginx:1.19 AS builder
# Some of the commands below require root privileges
USER root
# Do not hardcode app version
ARG WORDPRESS_VERSION=5.7
# Install necessary packages for building/downloading the app
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates curl
RUN rm -r /var/lib/apt/lists /var/cache/apt/archives
# Download the application and reset ownership/permissions
# Verify that there are no files with extraneous permissions manually via command: find /wordpress/ -type d -not -perm 755 -o -type f -not -perm 644
RUN curl -s https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz | tar xz -C / --no-same-owner --no-same-permissions
# Remove any non-asset file
RUN find . -type f -not \( -name '*.css' -o -name '*.eot' -o -name '*.gif' -o -name '*.html' -o -name '*.jpg' -o -name '*.js' -o -name '*.png' -o -name '*.scss' -o -name '*.svg' -o -name '*.ttf' -o -name '*.woff' \) -delete

# Use a minimal base image
FROM bitnami/nginx:1.19
# Some of the commands below require root privileges
USER root
# Install the application on the final image
COPY --from=builder /wordpress /wordpress
# Volume where to store app data files
RUN mkdir /wp-content && chmod g+rwX /wp-content
VOLUME [ "/wp-content" ]
# Run as a non-root user
USER 1001
# Define the default location where the app code will live
WORKDIR /wordpress
# Define list of ports that may be exposed at runtime
EXPOSE 8080 8443
