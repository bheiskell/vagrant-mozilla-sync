Vagrant Configuration for Mozilla Sync Server
=============================================

This vagrant/puppet configuration will generate a Mozilla Sync VM which can be
used with Firefox.

Change all instances of "example.com" to match your DNS host of choice
(./provision/sync.conf & ./manifests/base.pp). The configured hostname and port
must match the URI you plan to provide to Firefox.

Installation
------------

    cd modules
    ./get_modules.sh
    cd ..
    vagrant up
