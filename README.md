This vagrant/puppet configuration will generate a Mozilla Sync VM which can be used with FireFox.

Installation

cd modules
./get_modules.sh

Change fallback_node in provision/sync.conf from "http://sync.example.com:8080/" to whatever your front-end URI will be.
