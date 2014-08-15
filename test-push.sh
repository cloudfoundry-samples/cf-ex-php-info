#!/bin/bash
# Test different configurations of PHP, Nginx & HTTPD
set -e

# start with a clean slate
git co .bp-config/options.json

# push with Nginx
echo "Testing Nginx Configuration"
cp .bp-config/options-nginx.json .bp-config/options.json
cf push > logs/nginx.log
./test-extensions.sh 5.4.31

# push with HTTPD
echo "Testing HTTPD Configuration"
cp .bp-config/options-httpd.json .bp-config/options.json
cf push > logs/httpd.log
./test-extensions.sh 5.4.31

# push with PHP 5.5
echo "Testing PHP 5.5 Configuration"
cp .bp-config/options-php55.json .bp-config/options.json
cf push > logs/php55.log
./test-extensions.sh 5.5.15

# push with PHP 5.4 & opcache
echo 'Testing PHP 5.4 w/OpCache'
cp .bp-config/options-php54opcache.json .bp-config/options.json
cf push > logs/opcache.log
./test-extensions.sh 5.4.31 opcache

# push with PHP 5.5 & opcache
echo 'Testing PHP 5.5 w/OpCache'
cp .bp-config/options-php55opcache.json .bp-config/options.json
cf push > logs/opcache.log
./test-extensions.sh 5.5.15 opcache

# return to default
git co .bp-config/options.json
