#!/bin/bash

#create a cron job to auto renew certificate when it expery (every 3 months)
add-auto-renewal-cronjob () {

  $letsencryptAuto = $0

  crontab -l > mycron
  if [ ! -d /var/log/letsencrypt ]; then

    echo "creating /var/log/letsencrypt folder"
    mkdir /var/log/letsencrypt || echo "not enough right to create folder"

  fi
  echo "30 3 * * 0 $letsencryptAuto renew >> /var/log/letsencrypt/renewal.log" >> mycron

  crontab mycron
  rm mycron

}
