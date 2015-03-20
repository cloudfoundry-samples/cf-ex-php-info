#!/bin/bash
# Test different configurations of PHP, Nginx & HTTPD
set -e

PHP54="5.4.39"
PHP55="5.5.23"
PHP56="5.6.7"
HHVM32="3.2.0"

# init out test log
touch logs/tests_passed.log

# start with a clean slate
rm -f .bp-config/options.json

TESTS[1]="nginx-$PHP54-apc"
TESTS[2]="httpd-$PHP54-apc"
TESTS[3]="php55-$PHP55-apc"
TESTS[4]="php54opcache-$PHP54-opcache"
TESTS[5]="php55opcache-$PHP55-opcache"
TESTS[6]="php54xcache-$PHP54-xcache"
TESTS[7]="php55xcache-$PHP55-xcache"
TESTS[8]="php56-$PHP56-apc"
TESTS[9]="nginx17-$PHP55-apc"
TESTS[10]="hhvm-$HHVM32-hhvm"

function test_iteration() {
    CFG=$1
    PHPVER=$2
    CACHE=$3
    if [ $(grep "$CFG" logs/tests_passed.log | wc  -l) == 0 ]; then
        echo "Testing Configuration [$CFG]"
        cp ".bp-config/options-$CFG.json" .bp-config/options.json
        cf push > "logs/$CFG.log"
        ./test-extensions.sh "$PHPVER" "$CACHE" 2>> "logs/$CFG.log"
        echo "$CFG" >> logs/tests_passed.log
    else
        echo "Skipping Configuration [$CFG]"
    fi
}

# Run all tests
for TEST in "${!TESTS[@]}"; do
    echo "--------------------------------------------------------------"
    TMP=${TESTS[$TEST]}
    CFG=$(echo "$TMP" | cut -d '-' -f 1)
    PHPV=$(echo "$TMP" | cut -d '-' -f 2)
    CACHE=$(echo "$TMP" | cut -d '-' -f 3)
    test_iteration "$CFG" "$PHPV" "$CACHE"
done

# push with NewRelic
if [ "$NEWRELIC_ENABLED" != "" ]; then
    echo "Testing NewRelic Configuration"
    cp manifest-nr.yml manifest.yml
    test_iteration "newrelic" "$PHP54" "apc"
    git co manifest.yml
fi

# return to default
rm -f .bp-config/options.json
