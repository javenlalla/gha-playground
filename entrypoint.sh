#!/bin/bash
set -e

for variable in "${required_variables[@]}"
do
  if [[ -z ${!variable+x} ]]; then
    echo >&2 "error: environment variable ${variable} missing"
    exit 1
  fi
done

# Configure the .env file.
> .env
echo "DATABASE_URL=sqlite:////database/app.db" >> .env
echo "MESSENGER_TRANSPORT_DSN=doctrine://default?auto_setup=0" >> .env

if [[ $APP_ENV != "prod" ]]; then
    # Note: it is intentional that the APP_ENV is written to the .env file instead of declared in the Dockerfile.dev because the container Environment Variables take precedence over the .env file(s).
    # As a result, running tests in the development environment fail due to not switching to the test environment programmatically when running. The following error is thrown:
    # Symfony\Component\DependencyInjection\Exception\ServiceNotFoundException: You have requested a non-existent service "test.service_container". Did you mean this: "service_container"?
    # So to address this and have the command line switch environments correctly during tests, the APP_ENV variable is written to the .env file.
    # See the following page for more info: https://symfony.com/doc/current/configuration.html#overriding-environment-values-via-env-local
    # "Real environment variables always win over env vars created by any of the .env files."
    echo "APP_ENV=dev" >> .env
fi

# Generate APP_SECRET.
export APP_SECRET=$(openssl rand -base64 40 | tr -d /=+ | cut -c -32)
echo "APP_SECRET=${APP_SECRET}" >> .env

# Install and configure composer dependencies.
if [[ $APP_ENV = "prod" ]]; then
    echo "Installing composer dependencies."
    composer install --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress
    composer clear-cache
    composer dump-autoload --classmap-authoritative --no-dev
    composer dump-env prod
    composer run-script --no-dev post-install-cmd
else
  echo "Installing composer dependencies. This will take a few minutes since xdebug is installed."
  composer install
fi

# Execute any pending database migrations and console commands.
if [ -f /var/www/symf/migrations/Version*.php ]; then
    # Once database is reachable, execute any pending migrations and console commands.
    echo "Migration files exist. Execute migration."
    php bin/console doctrine:migrations:migrate --no-interaction
fi

# Fix permissions, espeically to address `var` folder not being writeable for cache and logging.
if [ -d "/var/www/symf" ]; then
    # Fix permissions, especially to address `var` folder not being writeable for cache and logging.
    echo "Fixing application folder permissions."
    chown -R www-data:www-data /var/www/symf
fi

# Container is set up. Start services.
echo "Starting services."
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf