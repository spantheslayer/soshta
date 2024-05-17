# main image
FROM php:8.1-apache

# installing dependencies
RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    libfreetype6-dev \
    libicu-dev \
    libgmp-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    libzip-dev \
    unzip \
    zlib1g-dev

# configuring php extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-configure intl

# installing php extension
RUN docker-php-ext-install bcmath calendar exif gd gmp intl mysqli pdo pdo_mysql zip

# installing composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# installing node js
COPY --from=node:latest /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:latest /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# installing global node dependencies
RUN npm install -g npx
RUN npm install -g laravel-echo-server

# setting work directory
WORKDIR /var/www/html/

# adding user
RUN useradd -G www-data,root -u 1000 -d /home/bagisto bagisto
RUN mkdir -p /home/bagisto/.composer && \
    chown -R bagisto:bagisto /home/bagisto

# setting apache
COPY ./.configs/apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# setting up project from `src` folder
RUN chmod -R 775 /var/www/html/
RUN chown -R bagisto:www-data /var/www/html/

# changing user
USER $user

RUN mkdir -p /home/bagisto/bagisto
COPY . /home/bagisto/bagisto
RUN cd /home/bagisto/bagisto && composer install

COPY entrypoint.sh /bin/entrypoint.sh
CMD ["/bin/entrypoint.sh"]
