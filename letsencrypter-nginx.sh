#!/bin/bash

source ./auto-renewal.sh

install-letsencrypt () {

  $installationPath = $0

  git clone https://github.com/letsencrypt/letsencrypt $installationPath

}

if ( ! type letsencrypt-auto > /dev/null 2>&1 ); then

  echo "letsencrypt-auto was not found"
  echo "do you want to it to be installed automatically y/n?"
  echo "it will be installed in ~/letsencrypt"

  read install
  if [ "y" = "$install" ]; then

    git clone https://github.com/letsencrypt/letsencrypt ~/letsencrypt
    cd ~/letsencrypt

  else

    echo "aborting. Install letsencrypt and rerun the script"
    exit 0
  fi
fi

echo "domain to encrypt"
read domain

echo "document root"
read documentRoot

echo "nginx site vhost absolute path"
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
         server_name $domain
         ssl on;
         ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
         ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

         root $documentRoot;
         # Add index.php to the list if you are using PHP
         index index.html index.htm index.nginx-debian.html;


}" >> $nginxVhost

sudo nginx -t && sudo service nginx reload || echo "an error occured"

echo "do you want to add certificate auto renewal with a cron job  ? y/n"

read autoRenew
if [ "y" = "$autoRenew" ]; then

  add-auto-renewal-cronjob
fi

echo "Done."
echo "Please check that your nginx config file is the way you want and edit it accordingly"
echo "Not everything is automated yet"
