#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/auto-renewal.sh

if [ ! type letsencrypt-auto > /dev/null 2>&1 ]; then

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

substitution="location ~ /\\\.well-known/acme-challenge { allow all; }"
sudo sed --in-place -re "s|server \{|server \{\n\n    $substitution|" $nginxVhost || {  echo "file $nginxVhost cannot be written. exiting"; exit 1; }

sudo nginx -t && sudo service nginx reload || { echo "invalid nginx configuration please check your vhost; exiting"; exit 1; }

echo "asking letsencrypt for certificates..."
letsencrypt-auto certonly --rsa-key-size 4096 --webroot \
     --webroot-path $documentRoot \
     -d $domain || { echo "error during certificate requests. exiting"; exit 1; } 
echo "the certificates were successfully downloaded. you can find them in /etc/letsencrypt/live"

echo "do you want to add certificate auto renewal with a cron job  (certificates only last 3 months)? y/n"
read autoRenew
if [ "y" = "$autoRenew" ]; then

  add-auto-renewal-cronjob
fi
echo "done"


substitution="location / { return 301 https://$domain\$request_uri; }"
sslServer="server {

         listen 443 ssl;
         listen [::]:443 ssl;
         server_name $domain
         ssl on;
         ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
         ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

         root $documentRoot;
         # Add index.php to the list if you are using PHP
         index index.html index.htm index.nginx-debian.html;
}"


echo "the following configuration snippets might be usefull,
 do you want to be added automatically to your vhost ? (y/n)"

echo $substitution
echo $sslServer

echo "notice: some additional editing might be required"
read autoConf

if [ "y" = "$autoConf"]; then

   echo "adding http to https redirection"
   sudo sed --in-place -re "s|server \{| server {\n\n    $substitution|" $nginxVhost
   echo "done"

   echo "adding server directive for ssl"
   echo $sslServer | sudo tee --append $nginxVhost > /dev/null
   echo "done"

   echo "reload nginx configuration"
   sudo nginx -t && sudo service nginx reload || { echo "the new configuration needs additional edition for working"; }
fi


echo "end of script, please check your setup"
