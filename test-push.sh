#!/bin/bash
# Test different configurations of PHP, Nginx & HTTPD
set -e

# start with a clean slate
git co .bp-config/options.json

# push with Nginx
cfenv pws
cp .bp-config/options-nginx.json .bp-config/options.json
cf push
./test-extensions.sh 5.4.31

# push with HTTPD
cfenv pws
cp .bp-config/options-httpd.json .bp-config/options.json
cf push
./test-extensions.sh 5.4.31

# push with PHP 5.5
cfenv pws
cp .bp-config/options-php55.json .bp-config/options.json
cf push
./test-extensions.sh 5.5.15
