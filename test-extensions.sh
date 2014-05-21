#!/bin/bash

# get URL
URL=http://$(cf app php-info | grep "urls:" | cut -d ':' -f 2 | sed -e 's/^ *//' -e 's/ *$//')/info.php
echo "Test URL is [$URL]"

# load results from info.php
DATA=$(curl -s "$URL")

function test_exten {
    if [[ $DATA != *"<a name=\"module_$1\">$1</a>"* ]]
    then
        echo "Extension not found [$1]!!"
    fi
}

# check for each PHP extension
echo "Checking for extensions that didn't load.  Missing extensions listed below."

test_exten 'amqp'
test_exten 'apc'
test_exten 'bz2'
test_exten 'curl'
test_exten 'dba'
test_exten 'gd'
test_exten 'gettext'
test_exten 'gmp'
test_exten 'igbinary'
test_exten 'imap'
test_exten 'ldap'
test_exten 'mcrypt'
test_exten 'memcache'
test_exten 'memcached'
test_exten 'mongo'
test_exten 'msgpack'
test_exten 'openssl'
test_exten 'pdo_pgsql'
test_exten 'pgsql'
test_exten 'pspell'
test_exten 'redis'
test_exten 'snmp'
test_exten 'zlib'
test_exten 'xdebug'

echo 'Done'

