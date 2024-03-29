# Build the main image.
FROM php:8.1.7-fpm-buster

ENV APP_ENV=prod
ENV APP_PUBLIC_PATH=/var/www/app/public
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV APP_ID=gha-app
ARG APP_VERSION
ENV APP_VERSION=$APP_VERSION

RUN apt update && apt install -y \
    curl \
    git \
    cron \
    # zip/unzip packages required for Composer in order to install packages.
    zlib1g-dev \
    libzip-dev \
    unzip \
    nginx \
    supervisor \
    # libicu-dev is a dependency required by the `intl` extension.
    libicu-dev

RUN docker-php-ext-install \
    pdo \
    intl \
    # sysvsem is required for the RateLimiter Semaphore store.
    sysvsem

RUN docker-php-ext-install zip

# Clean up apt cache.
RUN rm -rf /var/lib/apt/lists/*

# Configure php.
COPY php.prod.ini /usr/local/etc/php/php.ini

# Install Composer.
# https://stackoverflow.com/a/58694421
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN echo "export PATH=$HOME/.composer/vendor/bin:$PATH" >> $HOME/.profile

# Copy application to image.
RUN mkdir /var/www/app/
COPY src /var/www/app
WORKDIR /var/www/app
RUN rm -rf var

# Install Composer dependencies.
RUN set -eux; \
	mkdir -p var/cache var/log; \
    if [ -f composer.json ]; then \
        composer install --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress; \
		composer clear-cache; \
		composer dump-autoload --classmap-authoritative --no-dev; \
		composer dump-env prod; \
		composer run-script --no-dev post-install-cmd; \
		chmod +x bin/console; sync; \
    fi

# Configure Nginx.
COPY nginx-site.conf /etc/nginx/sites-enabled/default

# Configure Entrypoint.
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

# Configure Supervisor.
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Additional folder setup.
RUN mkdir /database

ENTRYPOINT ["/entrypoint.sh"]