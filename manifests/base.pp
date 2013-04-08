Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

package {['vim', 'screen', 'sqlite3', 'build-essential']: ensure => 'present' }

file { '/etc/motd':
  content => "Sync server for xdxa.org."
}

class {'apache':
}
class {'apache::mod::wsgi':
}

apache::vhost { 'sync.xdxa.org':
    priority        => '10',
    vhost_name      => '*',
    port            => '80',
    docroot         => '/var/www',
    serveradmin     => 'ben.heiskell@xdxa.org',
    template        => 'sync.conf.erb',
}

class { 'python':
    dev        => true,
    virtualenv => true,
}

class {'mercurial':
}

mercurial::clone { '/var/www/sync':
  source => 'https://hg.mozilla.org/services/server-full',
}

exec { 'chown-root':
    command => 'chown -R root:root /var/www',
}
exec { 'chown-www-data':
    command => 'chown -R www-data:www-data /var/www',
}

exec { 'build-sync':
    user => 'www-data',
    cwd => '/var/www/sync',
    command => 'pwd 1>&2 && make build CHANNEL=dev && make test',
    #creates => '/var/www/sync/lib/python2.7/site-packages',
    timeout => 0,
    #subscribe => Exec['hg-pull-/var/www/sync'],
    #refreshonly => true,
    logoutput => true,
}

file { '/var/www/sync/etc/sync.conf':
    source => '/mnt/provision/sync.conf',
    owner => 'www-data',
    group => 'www-data',
}

file { '/var/www':
    ensure => 'directory',
}

file { '/var/sqlite':
    ensure => 'directory',
    owner => 'www-data',
    group => 'www-data',
}

file { '/var/sqlite/sync.db':
    ensure => 'present',
    owner => 'www-data',
    group => 'www-data',
}

Mercurial::Clone['/var/www/sync'] <- File['/var/www']

# Mecurial doesn't allow a user to be specified (should probably just patch that
Exec['chown-root'] -> Mercurial::Clone['/var/www/sync'] -> Exec['chown-www-data']

Exec['build-sync'] <- Exec['chown-www-data']
Exec['build-sync'] <- Class['python']
Exec['build-sync'] <- Package['sqlite3']
Exec['build-sync'] <- Package['build-essential']
Exec['build-sync'] <- Package['python-virtualenv']
Exec['build-sync'] <- Mercurial::Clone['/var/www/sync']

Exec['build-sync'] -> File['/var/www/sync/etc/sync.conf']
Exec['build-sync'] -> File['/var/sqlite/sync.db']

Apache::Vhost['sync.xdxa.org'] <- File['/var/www/sync/etc/sync.conf']
Apache::Vhost['sync.xdxa.org'] <- File['/var/sqlite/sync.db']
