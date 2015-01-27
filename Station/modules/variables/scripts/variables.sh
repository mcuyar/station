#!/usr/bin/env bash

path='/etc/php5/fpm/station.conf'
pattern="include=$path"

if [ ! -f $path ]; then sudo touch $path ; fi

if ! grep -Fxq "$pattern" /etc/php5/fpm/php-fpm.conf ; then
    echo -e "$pattern" >> /etc/php5/fpm/php-fpm.conf
fi