class nginx (
$package = $nginx::params::package,
$owner = $nginx::params::owner,
$group = $nginx::params::group,
$docroot = $nginx::params::docroot,
$confdir = $nginx::params::confdir,
$logdir = $nginx::params::logdir,
$user = $nginx::params::user,
) inherits nginx::params {
File {
owner => $owner,
group => $group,
mode => '0664',
}
package { $package:
ensure => present,
}
file { [ $docroot, "${confdir}/conf.d" ]:
ensure => directory,
}
file { "${docroot}/index.html":
ensure => file,
source => 'puppet:///modules/nginx/index.html',
}
file { "${confdir}/nginx.conf":
ensure => file,
content => template('nginx/nginx.conf.erb'),
notify => Service['nginx'],
}
file { "${confdir}/conf.d/default.conf":
ensure => file,
content => template('nginx/default.conf.erb'),
notify => Service['nginx'],
}
service { 'nginx':
ensure => running,
enable => true,
}
}
