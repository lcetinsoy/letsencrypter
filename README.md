# letsencrypter

### Not ready ! Your help is welcome

A small script to easy letsencrypt workflow for nginx setup

Not everything is automated you will have still to manually edit your vhost
so it fits your setup.

## What it does

- edit your vhost so that letsencrypt-auto can receive certificates without
  stoping nginx
- run the command with a rsa-key-size of 4096
- add location for https with all ssl parameters


What it does not do :

- Add a redirection in location from http to https

## Installation

$ git clone https://github.com/lcetinsoy/letsencrypter

(optional)

$ sudo ln -l letsencrypter-nginx.sh /usr/local/bin/letsencrypter

## Usage

$ ./letsencrypter-nginx.sh

## Contribute

Fork and pull requestion. No tests automated test for now. I know, I'm no good
