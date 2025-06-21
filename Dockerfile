# Multi-stage build for optimized container
FROM nginx:alpine as nginx-base

# Install PHP-FPM
RUN apk add --no-cache \
    php81 \
    php81-fpm \
    php81-pdo \
    php81-pdo_mysql \
    php81-mysqli \
    php81-json \
    php81-openssl \
    php81-curl \
    php81-zlib \
    php81-xml \
    php81-phar \
    php81-intl \
    php81-dom \
    php81-xmlreader \
    php81-ctype \
    php81-session \
    php81-mbstring \
    php81-gd \
    supervisor

# Create PHP symlink
RUN ln -s /usr/bin/php81 /usr/bin/php

# Copy nginx configuration
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy PHP-FPM configuration
RUN echo "listen = 127.0.0.1:9000" >> /etc/php81/php-fpm.d/www.conf

# Copy supervisor configuration
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy application files
COPY . /var/www/html

# Set proper permissions
RUN chown -R nginx:nginx /var/www/html \
    && chmod -R 755 /var/www/html

# Create required directories
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /run/nginx

# Expose port 80
EXPOSE 80

# Start supervisor to manage nginx and php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
