#FROM php:7.4.6-apache
FROM php:8.0-apache-bullseye
#FROM php:8.1-apache
#FROM php:8.2.3-apache

LABEL maintainer="fernando.ribeiro357@gmail.com"

# Usando https para evitar bloqueio de firewall
RUN echo "deb https://deb.debian.org/debian bullseye main " > /etc/apt/sources.list              && \
    echo "deb https://security.debian.org/debian-security bullseye-security/updates main" >> /etc/apt/sources.list && \
    echo "deb https://deb.debian.org/debian bullseye-updates main" >> /etc/apt/sources.list     && \
# Ajuste de timezone para Sao_Paulo
    rm /etc/localtime                                                       && \
    ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime              && \
    apt-get update --fix-missing && apt-get upgrade -y                      && \
# Permissões para as extensões
    chmod -R +rw /usr/local/lib/php/extensions/                             && \
# Instalação de drivers necessários
    docker-php-ext-install pdo                                              && \
    apt-get install -y zlib1g-dev libicu-dev g++                            && \
    docker-php-ext-install intl                                             && \
# Para conversão string para outros tipos de encoding
    apt-get install -y libonig-dev                                          && \
    docker-php-ext-install mbstring                                         && \
# Conexao com o Postgres (PGSQL)
    apt-get install -y libpq-dev                                            && \
    docker-php-ext-install pgsql pdo_pgsql                                  && \
# Conexao com o Mariadb (Mysql)
    docker-php-ext-install mysqli                                           && \
# Biblioteca Ldap
    apt-get install libldap2-dev -y                                         && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/       && \
    docker-php-ext-install ldap                                             && \
# Geração e uso de QR Code
    apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev      && \
    docker-php-ext-configure gd --enable-gd --with-jpeg --with-freetype     && \
    docker-php-ext-install gd                                               && \
# Xdebug 3.1.5 (última versão com suporte a PHP 7.4) \
#    pecl install xdebug-3.1.5                                               && \
    pecl install xdebug-3.2.1                                               && \
    docker-php-ext-enable xdebug                                            && \
# Reduz restrição de TLS devido ao erro 'dh key too small' ao conectar no banco antigo PostgreSQL
    # sed -i 's/MinProtocol = TLSv1.2/MinProtocol = TLSv1.1/g' /etc/ssl/openssl.cnf && \
    # sed -i 's/CipherString = DEFAULT@SECLEVEL=2/CipherString = DEFAULT@SECLEVEL=1/g' /etc/ssl/openssl.cnf && \
# configuração do mod_rewrite
    a2enmod rewrite                                                         && \
# Habilitando ssl
    a2enmod ssl && a2enmod socache_shmcb                                    && \
# Composer
    apt install git zip unzip -y




# Configuração das variáveis de ambiente do APACHE
ENV SERVER_ADMIN 'fernando.ribeiro357@gmail.com'
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV HTDOCS /var/www/html

# Limpeza da pasta
RUN rm -R $HTDOCS

# Cópia inicial para o HTDOCS
WORKDIR $HTDOCS
COPY --chown=$APACHE_RUN_USER:$APACHE_RUN_GROUP src/ $HTDOCS/

# Allow
VOLUME $HTDOCS
#RUN chown -R $APACHE_RUN_USER $HTDOCS && chmod -R g+rw $HTDOCS

# Configuracao do Apache e PHP
COPY webserver/odbcinst.ini /etc/odbcinst.ini
COPY webserver/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
COPY webserver/apache-ssl-config.conf /etc/apache2/sites-enabled/default-ssl.conf
COPY webserver/apache2.conf /etc/apache2/apache2.conf
COPY webserver/mycert.crt /etc/ssl/certs/mycert.crt
COPY webserver/mycert.key /etc/ssl/private/mycert.key
COPY webserver/php.ini /usr/local/etc/php/php.ini

# COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN echo "\nexport PATH=\"vendor/bin:\$PATH\"" >> ~/.bashrc
# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
#    php composer-setup.php --quiet && \
#    rm composer-setup.php
# RUN php -r "copy('https://https://getcomposer.org/download/latest-stable/composer.phar', 'composer.phar');" && \
# RUN curl -o composer.phar https://getcomposer.org/download/latest-stable/composer.phar      && \
    # chmod +x composer.phar                                                                  && \
# RUN curl -o composer.phar https://getcomposer.org/download/latest-stable/composer.phar
# RUN chmod +x composer.phar
# RUN COMPOSER_ALLOW_SUPERUSER=1 ./composer.phar install
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
#COPY src/composer.json src/composer.lock ./
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer install 
RUN chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP $HTDOCS && chmod -R g+rw $HTDOCS

# Expose apache.
EXPOSE 80
EXPOSE 443

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND