#!/bin/sh

git clone https://bitbucket.org/oherrala/puppet.git puppet
git clone https://github.com/puppetlabs/puppetlabs-apache.git apache
git clone https://github.com/puppetlabs/puppetlabs-firewall.git firewall
git clone https://github.com/puppetlabs/puppetlabs-stdlib.git stdlib
git clone https://github.com/stankevich/puppet-python.git python
ln -s puppet/mercurial mercurial
