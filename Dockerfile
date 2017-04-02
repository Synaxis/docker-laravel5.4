#####################
# - Laravel v5.4.0 #
#####################
FROM php:7.1-apache
MAINTAINER "Bobby Hines <bobby@conflabs.com>"

# Update repos and install system/security updates
RUN ["apt-get","update"]
RUN ["apt-get","dist-upgrade","-y"]

# Install required utility programs
RUN ["apt-get","update"]
RUN ["apt-get","install","-y","git","libfreetype6-dev","libjpeg62-turbo-dev","libpng12-dev","nano","wget","zlib1g-dev","zip"]

# Export terminal processes for use of editors in container
ENV TERM xterm

# Install PHP Zip extension
RUN ["pecl","install","zip"]
RUN ["docker-php-ext-enable","zip"]

# Enable PDO mysql driver
RUN apt-get update &&\
    docker-php-ext-install -j$(nproc) pdo_mysql &&\
    docker-php-ext-configure pdo_mysql

# Install and configure GD library for mysql
RUN apt-get update &&\
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ &&\
    docker-php-ext-install -j$(nproc) gd

# Enable Pretty URLs
RUN ["a2enmod","rewrite"]

# Download and install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add composer to the $PATH
RUN echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc

# Add node.js PPA repo
WORKDIR /
RUN ["curl","-sL","https://deb.nodesource.com/setup_6.x","-o","nodesource_setup.sh"]
RUN ["bash","nodesource_setup.sh"]
RUN ["apt-get","install","-y","nodejs"]
RUN ["apt-get","install","-y","build-essential"]

# Adjust Apache config for new public directory
RUN ["rm","-Rf","/etc/apache2/sites-enabled/000-default.conf"]
RUN ["rm","-Rf","/etc/apache2/sites-active/000-default.conf"]
COPY ["./server_config/000-default.conf","/etc/apache2/sites-enabled/"]
COPY ["./server_config/000-default.conf","/etc/apache2/sites-active/"]

EXPOSE 80
WORKDIR /var/www/html
VOLUME /var/www/html
