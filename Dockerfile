FROM php:7.3-fpm-alpine

COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

COPY phpinfo.php /phpinfo.php
COPY error.php /error.php

RUN apk update && apk add bash

# Run PHP-FPM.
CMD ["php-fpm", "-F"]
