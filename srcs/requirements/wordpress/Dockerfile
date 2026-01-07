FROM debian:12

#install php and so on for wordpress
RUN apt-get update && \
	apt-get install -y \
	php7.4-fpm \
	php7.4-mysql \
	php7.4-curl \
	php7.4-gd \
	php7.4-mbstring \
	php7.4-xml \
	php7.4-xmlrpc \
	php7.4-soap \
	php7.4-intl \
	php7.4-zip \
	wget \
	curl \
	mariadb-client && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

#download wpcli

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

#copy php conf
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

#copy install script
COPY tools/install-wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/install-wordpress.sh

#expose ports
EXPOSE 9000

CMD ["/usr/local/bin/install-wordpress.sh"]

