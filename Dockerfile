FROM php:7.0-apache-stretch

# install system tools
RUN apt-get update && \
    apt-get install -y \
        git \
        git-core \
        curl \
        apt-utils \
        gnupg2 \
        openssl \
        openssh-server \
        sshpass \
        ssl-cert \
        sudo \
        unzip \
        wget \
        zip \
        make \
        libjpeg-dev \
        libpng-dev \
        libpq-dev \
        libmcrypt-dev \
        libxml2-dev \
        build-essential \
        cmake \
        debconf \
        locales

RUN pecl install redis && \
    pecl install xdebug
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-configure mysqli --with-mysqli=mysqlnd

RUN docker-php-ext-install calendar && \
    docker-php-ext-install gd && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install opcache && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install sockets && \
    docker-php-ext-install zip

RUN docker-php-ext-enable redis && \
    docker-php-ext-enable xdebug

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install node
RUN wget -qO- https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN mkdir -p /root/.npm
RUN CHMOD -R 777 /root/.npm
RUN mkdir -p /root/.composer
RUN CHMOD -R 777 /root/.composer
