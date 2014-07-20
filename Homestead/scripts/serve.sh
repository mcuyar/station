#!/usr/bin/env bash

block="server {
    listen 80;
    server_name $1;
    root $2;

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/$1-error.log error;

    error_page 404 /index.php;

    sendfile off;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;

        fastcgi_buffers 8 16k;
        fastcgi_buffer_size 32k;
        fastcgi_connect_timeout 300s;
        fastcgi_send_timeout 60;
        fastcgi_read_timeout 60;

        fastcgi_param PHP_VALUE \"xdebug.max_nesting_level = 0\";
        #fastcgi_param PHP_VALUE \"xdebug.remote_autostart=0\";
        #fastcgi_param PHP_VALUE \"xdebug.remote_enable=0\";
        #fastcgi_param PHP_VALUE \"xdebug.profiler_enable=0\";
    }

    location ~ /\.ht {
        deny all;
    }
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
service nginx restart
service php5-fpm restart
