#!/bin/bash

# are there any missing extensions?
MISSING=0

# get expected version
PHP_VERSION=$1
if [ "$PHP_VERSION" == "" ]; then
    echo "PRO TIP:  Set the expected version by passing an argument to this script.  Ex:  ./test-extensions.sh <version>"
fi

# cache to test
CACHE=$2

# get URL
URL=http://$(cf app php-info | grep "urls:" | cut -d ':' -f 2 | sed -e 's/^ *//' -e 's/ *$//')/info.php
echo "Test URL is [$URL]"

# load results from info.php
DATA=$(curl -s "$URL")

# dump results
>&2 echo "Got results."
>&2 echo "-------------------------------------------------------------------"
>&2 echo "$DATA"
>&2 echo "-------------------------------------------------------------------"

function test_exten {
    if [[ $DATA != *"<a name=\"module_$1\">$1</a>"* ]]
    then
        echo "Extension not found [$1]!!"
        MISSING=1
    fi
}

function test_version {
    if [[ $DATA != *"<h1 class=\"p\">PHP Version $1</h1>"* ]]
    then
        echo "PHP Version doesn't match!"
        MISSING=1
    else
        echo "Found PHP version $1"
    fi
}

if [ "$CACHE" == "hhvm" ]; then
    # HHVM doesn't output anything with phpinfo(), so it's not possible to validate 
    if [ "$DATA" == "HipHop" ]; then
        exit 0
    else
        echo 'Not the expected response from HHVM.'
        exit -1
    fi
fi

# test php version first
if [ "$PHP_VERSION" != "" ]; then
    test_version "$PHP_VERSION"
fi

# check for each PHP extension
echo "Checking for extensions that didn't load.  Missing extensions listed below."

test_exten 'amqp'
if [[ $PHP_VERSION == "5.4."* ]]; then
    if [ "$CACHE" == "" ]; then
        CACHE="apc"
    fi
    if [ "$CACHE" == "apc" ]; then
        test_exten 'apc'
        test_exten 'apcu'
    elif [ "$CACHE" == "opcache" ]; then
        test_exten 'Zend OPcache'
    elif [ "$CACHE" == "xcache" ]; then
        test_exten 'XCache'
        test_exten 'XCache Cacher'
    fi
fi
if [[ $PHP_VERSION == "5.5."* ]]; then
    if [ "$CACHE" == "opcache" ]; then
        test_exten 'Zend OPcache'
    elif [ "$CACHE" == "xcache" ]; then
        test_exten 'XCache'
        test_exten 'XCache Cacher'
    fi
fi
test_exten 'bz2'
test_exten 'curl'
test_exten 'dba'
test_exten 'exif'
test_exten 'fileinfo'
test_exten 'ftp'
test_exten 'gd'
test_exten 'gettext'
test_exten 'gmp'
test_exten 'igbinary'
test_exten 'imagick'
test_exten 'imap'
test_exten 'intl'
test_exten 'ldap'
test_exten 'mailparse'
test_exten 'mbstring'
test_exten 'mcrypt'
test_exten 'memcache'
test_exten 'memcached'
test_exten 'mongo'
test_exten 'msgpack'
test_exten 'mysql'
test_exten 'mysqli'
test_exten 'openssl'
test_exten 'PDO'
test_exten 'pdo_sqlite'
test_exten 'pdo_mysql'
test_exten 'pdo_pgsql'
test_exten 'pgsql'
test_exten 'phalcon'
test_exten 'phpiredis'
test_exten 'pspell'
test_exten 'redis'
test_exten 'snmp'
test_exten 'soap'
test_exten 'sockets'
test_exten 'sundown'
test_exten 'twig'
test_exten 'xdebug'
test_exten 'xsl'
test_exten 'zip'
test_exten 'zlib'

if [ "$NEWRELIC_ENABLED" != "" ]; then
    test_exten 'newrelic'
fi

if [ "$MISSING" == 1 ]; then
    echo "Something's not right, look at the output above."
    exit -1
fi

echo 'Done'

