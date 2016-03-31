# letsencrypter

###  In Beta, your help is welcome !

A small script to ease letsencrypt workflow for nginx setup

## What it does

- edit your vhost so that letsencrypt-auto can receive certificates without
  stoping nginx.
- run the command with a rsa-key-size of 4096.
- (optionnaly) add cron job to renew certificates every 3 months.
- (optionnaly) add ssl server directive and http to https redirection.


What it does not (yet):

- Generate certificates in one shot for multi domain with several "-d" arguments

## Installation

$ git clone https://github.com/lcetinsoy/letsencrypter

(optional)

$ sudo ln -l letsencrypter-nginx.sh /usr/local/bin/letsencrypter

## Usage

$ letsencrypter-nginx.sh

## Contribute

Fork and pull request. No tests automated test for now. I know, I'm no good

## Licence

MIT
