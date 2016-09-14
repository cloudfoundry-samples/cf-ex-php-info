CloudFoundry PHP example application:  phpinfo
==============================================

This is an example application which can be run on CloudFoundry using the [PHP Buildpack](https://github.com/cloudfoundry/php-buildpack).

This is a very simple application which exposes the phpinfo() data for the installation.  It's a good place to start and see what features are available on the system.

Usage
-----

Clone the app and push it to CloudFoundry.

```
git clone https://github.com/cloudfoundry-samples/cf-ex-php-info
cd cf-ex-php-info
cf push
```

Access your application URL in the browser.
