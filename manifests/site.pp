## site.pp ##

# This  file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Disable filebucket by default for all File resources:
File { backup => false }

# Randomize enforcement order to help understand relationships
ini_setting { 'random ordering':
  ensure  => present,
  path    => "${settings::confdir}/puppet.conf",
  section => 'agent',
  setting => 'ordering',
  value   => 'title-hash',
}

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
# This is where you can declare classes for all nodes.
# Example:
# class { 'my_class': }
include examples::fundamentals
include users
include skeleton
include memcached
include nginx
include epel
include htop
include aliases
include users::admins

#notify { "Hello, my name is ${::hostname}": }
#file { '/etc/motd':
# ensure => file,
# owner => 'root',
# group => 'root',
# mode => '0644',
# content => "Today I learned what it means to manage state using Puppet.\n",
#}

#if $::virtual != 'physical' {
#$vmname = capitalize($::virtual)
#notify { "This is a ${vmname} virtual machine.": }
#}

package { 'net-tools':
  ensure => present,
  provider => yum,
}

#exec { 'yum groupinstall Development Tools':
#  command => '/usr/bin/yum -y --disableexcludes=all groupinstall "Development Tools"',
#  unless  => '/usr/bin/yum grouplist "Development Tools" | /bin/grep "^Installed"',
#  timeout => 600 ,
#}

package { 'cowsay':
  ensure => present,
  provider => gem,
}

#exec { "cowsay 'Welcome to ${::fqdn}!' > /etc/motd":
#path => '/usr/bin:/usr/local/bin',
#creates => '/etc/motd',
#}
host { 'testing.puppetlabs.vm':
ensure => present,
ip => '127.0.0.1',
}

$message = hiera('message')
notify { $message: }


}

#class base {
#   yumrepo { "IUS":
#      baseurl => "http://dl.iuscommunity.org/pub/ius/stable/$operatingsystem/$operatingsystemrelease/$architecture",
#      descr => "IUS Community repository",
#      enabled => 1,
#      gpgcheck => 0
#   }
#}





