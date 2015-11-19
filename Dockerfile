################################################################################
# Base image
################################################################################

FROM nginx

################################################################################
# Build instructions
################################################################################

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# Install packages
RUN apt-get update && apt-get install -my \
  supervisor \
  curl \
  wget \
  php5-curl \
  php5-fpm \
  php5-gd \
  php5-xsl \
  php5-mysqlnd \
  php5-mcrypt \
  php5-xdebug

# Ensure that PHP5 FPM is run as root.
RUN sed -i "s/user = www-data/user = root/" /etc/php5/fpm/pool.d/www.conf
RUN sed -i "s/group = www-data/group = root/" /etc/php5/fpm/pool.d/www.conf

# Add configuration files
COPY conf/nginx.conf /etc/nginx/

RUN mkdir /etc/nginx/ez_params.d
COPY conf/ez_params.d/ez_fastcgi_params /etc/nginx/ez_params.d/
COPY conf/ez_params.d/ez_prod_rewrite_params /etc/nginx/ez_params.d/
COPY conf/ez_params.d/ez_rewrite_params /etc/nginx/ez_params.d/
COPY conf/ez_params.d/ez_server_params /etc/nginx/ez_params.d/

COPY conf/php.ini /etc/php5/fpm/conf.d/40-custom.ini

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www"]

################################################################################
# Ports
################################################################################

EXPOSE 80
