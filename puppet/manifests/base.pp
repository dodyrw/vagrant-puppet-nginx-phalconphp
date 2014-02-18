group { 'puppet':
	ensure => present,
}

exec { 'apt-get update': 
	command => '/usr/bin/apt-get update',
}

package { 'mc': 
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'nginx': 
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'php5-fpm':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'git-core':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'gcc':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'make':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'autoconf':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'php5-dev':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'php5-mysql':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'php5-cli':
        ensure => present,
        require => Exec['apt-get update'],
}

package { 'php5-gd':
        ensure => present,
        require => Exec['apt-get update'],
}

package { 'php5-curl':
        ensure => present,
        require => Exec['apt-get update'],
}

package { 'curl':
        ensure => 'present',
        require => Exec['apt-get update'],
}

service { 'nginx':
	ensure => running,
	require => Package['nginx'],
}

service { 'php5-fpm':
	ensure => running,
	require => Package['php5-fpm'],
}

file { 'vagrant-nginx':
	path => '/etc/nginx/sites-available/vagrant',
	ensure => file,
    replace => true,
	require => Package['nginx'],
	source => 'puppet:///modules/nginx/vagrant',
    notify => Service['nginx'],
}

file { 'default-nginx-disable':
	path => '/etc/nginx/sites-enabled/default',
	ensure => absent,
	require => Package['nginx'],
}

file { 'vagrant-nginx-enable':
	path => '/etc/nginx/sites-enabled/vagrant',
	target => '/etc/nginx/sites-available/vagrant',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['vagrant-nginx'],
		File['default-nginx-disable'],
	],
}

file { '/tmp/install-phalcon.sh':
	ensure => present,
        mode => '777',
	source => 'puppet:///modules/phalcon/install-phalcon.sh'
}

exec { 'exec_install-phalcon':
	command => '/tmp/install-phalcon.sh',
	require => File['/tmp/install-phalcon.sh'],
	onlyif => '/bin/ls -a /usr/lib/php5/* | /bin/grep -c phalcon.so',
}



class mysql ($root_password = 'root', $config_path = 'puppet:///modules/mysql/vagrant.cnf') {
  $bin = '/usr/bin:/usr/sbin'

  if ! defined(Package['mysql-server']) {
    package { 'mysql-server':
      ensure => 'present',
    }
  }

  if ! defined(Package['mysql-client']) {
    package { 'mysql-client':
      ensure => 'present',
    }
  }

  service { 'mysql':
    alias   => 'mysql::mysql',
    enable  => 'true',
    ensure  => 'running',
    require => Package['mysql-server'],
  }

  # Override default MySQL settings.
  #file { '/etc/mysql/conf.d/vagrant.cnf':
  #  owner   => 'mysql',
  #  group   => 'mysql',
  #  source  => $config_path,
  #  notify  => Service['mysql::mysql'],
  #  require => Package['mysql-server'],
  #}

  # Set the root password.
  exec { 'mysql::set_root_password':
    unless  => "mysqladmin -uroot -p${root_password} status",
    command => "mysqladmin -uroot password ${root_password}",
    path    => $bin,
    require => Service['mysql::mysql'],
  }

  # Delete the anonymous accounts.
  #mysql::user::drop { 'anonymous':
  #  user => '',
  #}
}

include 'mysql'
