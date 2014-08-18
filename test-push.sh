#!/bin/bash
# Test different configurations of PHP, Nginx & HTTPD
set -e

PHP54="$PHP54"
PHP55="$PHP55"

# start with a clean slate
git co .bp-config/options.json

# push with Nginx
echo "Testing Nginx Configuration"
cp .bp-config/options-nginx.json .bp-config/options.json
cf push > logs/nginx.log
./test-extensions.sh $PHP54

# push with HTTPD
echo "Testing HTTPD Configuration"
cp .bp-config/options-httpd.json .bp-config/options.json
cf push > logs/httpd.log
./test-extensions.sh $PHP54

# push with PHP 5.5
echo "Testing PHP 5.5 Configuration"
cp .bp-config/options-php55.json .bp-config/options.json
cf push > logs/php55.log
./test-extensions.sh $PHP55

# push with PHP 5.4 & opcache
echo 'Testing PHP 5.4 w/OpCache'
cp .bp-config/options-php54opcache.json .bp-config/options.json
cf push > logs/opcache54.log
./test-extensions.sh $PHP54 opcache

# push with PHP 5.5 & opcache
echo 'Testing PHP 5.5 w/OpCache'
cp .bp-config/options-php55opcache.json .bp-config/options.json
cf push > logs/opcache55.log
./test-extensions.sh $PHP55 opcache

# push with PHP 5.4 & xcache
echo 'Testing PHP 5.4 w/xcache'
cp .bp-config/options-php54xcache.json .bp-config/options.json
cf push > logs/xcache54.log
./test-extensions.sh $PHP54 xcache

# push with PHP 5.5 & xcache
echo 'Testing PHP 5.5 w/xcache'
cp .bp-config/options-php55xcache.json .bp-config/options.json
cf push > logs/xcache55.log
./test-extensions.sh $PHP55 xcache

# return to default
git co .bp-config/options.json
