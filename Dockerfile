######################
#   PHP DEV IMAGE    #
######################
# - Apache2 v2.4.25  #
# - PHP v7.1         #
# - Composer v1.3.1  #
# - PHPUnit          #
# - PHP Code Sniffer #
# - NodeJS           #
######################
FROM php:7.1-apache
MAINTAINER "Bobby Hines <bobby@conflabs.com>"

# Export terminal processes for use of editors in container
ENV TERM xterm

# Update repos and install system/security updates
RUN ["apt-get","update"]
RUN ["apt-get","dist-upgrade","-y"]

# Install required utility programs
RUN ["apt-get","update"]
RUN ["apt-get","install","-y","git","libfreetype6-dev","libjpeg62-turbo-dev","libpng12-dev","nano","wget","zlib1g-dev","zip"]

# Configure Timezone
RUN echo America/Los_Angeles >/etc/timezone && \
	ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
	dpkg-reconfigure -f noninteractive tzdata

# Install/Enable PHP Zip extension
RUN ["docker-php-ext-install","zip"]
#RUN ["docker-php-ext-enable","zip"]

# Install/Enable PDO mysql driver
RUN apt-get update &&\
    docker-php-ext-install -j$(nproc) pdo_mysql &&\
    docker-php-ext-configure pdo_mysql

#Install/Enable gd library
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Install composer and put binary into $PATH
#RUN curl -sS https://getcomposer.org/installer | php \
#    && mv composer.phar /usr/local/bin/ \
#    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Install phpunit and put binary into $PATH
RUN curl -sSLo phpunit.phar https://phar.phpunit.de/phpunit.phar \
    && chmod 755 phpunit.phar \
    && mv phpunit.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpunit.phar /usr/local/bin/phpunit

# Install PHP Code sniffer
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && chmod 755 phpcs.phar \
    && mv phpcs.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpcs.phar /usr/local/bin/phpcs \
    && curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && chmod 755 phpcbf.phar \
    && mv phpcbf.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpcbf.phar /usr/local/bin/phpcbf

# Add node.js PPA repo, then install it and get dependencies
WORKDIR /
RUN ["curl","-sL","https://deb.nodesource.com/setup_6.x","-o","nodesource_setup.sh"]
RUN ["bash","nodesource_setup.sh"]
RUN ["apt-get","install","-y","nodejs"]
RUN ["apt-get","install","-y","build-essential"]

# Enable Pretty URLs
RUN ["a2enmod","rewrite"]

# Adjust Apache config for new public directory
RUN ["rm","-Rf","/etc/apache2/sites-enabled/000-default.conf"]
RUN ["rm","-Rf","/etc/apache2/sites-active/000-default.conf"]
COPY ["./server_config/000-default.conf","/etc/apache2/sites-enabled/"]
COPY ["./server_config/000-default.conf","/etc/apache2/sites-active/"]

EXPOSE 80

WORKDIR /var/www/html
VOLUME /var/www/html
