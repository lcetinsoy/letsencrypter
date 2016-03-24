#!/bin/bash

if ( ! type letsencrypt-auto ); then

  echo "letsencrypt-auto was not found"
  echo "provide a path to it. Leave blank for automatic installation
  in ~/letsencrypt"

fi

echo "domain to encrypt"
read domain

echo "document root"
read documentRoot

echo "nginx site vhost path"
read nginxVhost

#for lets encrypt process
echo "location ~ /\.well-known/acme-challenge {
        allow all;
    }" >> $nginxVhost


sudo letsencrypt-auto certonly --rsa-key-size 4096 --webroot \
     --webroot-path $documentRoot \
     -d $domain

sudo nginx -t && sudo service nginx reload

echo "server {

         listen 443 ssl;
         listen [::]:443 ssl default_server;

         ssl on;
         ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
         ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

         root $documentRoot;
         # Add index.php to the list if you are using PHP
         index index.html index.htm index.nginx-debian.html;
         location / {

         }



}" >> $nginxVhost



sudo nginx -t && sudo service nginx reload


echo "end"
