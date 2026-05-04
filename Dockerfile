FROM php:8.2-fpm-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    supervisor \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    unzip \
    curl \
    ca-certificates \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) pdo_mysql gd zip opcache \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY . /var/www/html
COPY .zeabur/nginx.conf /etc/nginx/conf.d/default.conf
COPY .zeabur/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY .zeabur/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
  && mkdir -p /var/lib/nginx /var/log/supervisor /run/php /run/nginx \
  && chown -R www-data:www-data /var/www/html /var/lib/nginx /var/log/nginx /var/log/supervisor /run/php /run/nginx

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
