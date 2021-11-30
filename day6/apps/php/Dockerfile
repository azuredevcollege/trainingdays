FROM php:7.3-apache
RUN apt-get update -y && apt-get install curl mariadb-client-10.5 -y
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN mkdir /var/www/html/images
RUN chmod 777 /var/www/html/images
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost/ || exit 1
COPY ./php/ /var/www/html/
