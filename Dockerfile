# build environment
FROM idebot/docker-laravel-barebones as builder
WORKDIR /var/www/laravel
COPY . /var/www/laravel
RUN composer install --no-dev

# production environment
FROM phusion/baseimage

RUN apt update && apt install --no-install-recommends nginx php-fpm -y
RUN mkdir -p /var/www/app/public

COPY --from=builder /var/www/laravel /var/www/app
COPY default.conf /etc/nginx/sites-available/default

ARG DB_DATABASE=homestead
ARG DB_USERNAME=homestead
ARG DB_PASSWORD=secret

RUN chmod -R o+w /var/www/app/bootstrap/cache \ 
    && chmod -R o+w /var/www/app/storage \
    && cp /var/www/app/.env.example /var/www/app/.env \
    && sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/g' /var/www/app/.env \
    && sed -i "s/DB_DATABASE=homestead/DB_DATABASE=${DB_DATABASE}/g" /var/www/app/.env \
    && sed -i "s/DB_USERNAME=homestead/DB_USERNAME=${DB_USERNAME}/g" /var/www/app/.env \
    && sed -i "s/DB_PASSWORD=secret/DB_PASSWORD=${DB_PASSWORD}/g" /var/www/app/.env \
    && php /var/www/app/artisan key:generate

RUN mkdir /etc/service/start-server
ADD start-server.sh /etc/service/start-server/run
EXPOSE 80