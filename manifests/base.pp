/*

== Class: drbd::base

Basic class which installs the drbd modules and tools, and enables the service
at boot time.

Usage:

  include drbd::base


*/

class drbd::base {

          yumrepo { "elrepo":
            descr => "Elrepo",
            baseurl => "http://elrepo.org/linux/testing/el6/\$basearch/",
            enabled => 1,
            gpgcheck => 0,
          }

          package { "drbd83-utils":
            ensure  => present,
            alias   => "drbd",
            require => Yumrepo["elrepo"],
          }

          package { "kmod-drbd83":
            ensure  => present,
            alias   => "drbd-module",
            require => Yumrepo["elrepo"],
          }
   
  # this file just includes other files
  file { "/etc/drbd.conf":
    ensure  => present,
    mode    => "0644",
    owner   => "root",
    content => '# file managed by puppet
include "/etc/drbd.conf.d/*.conf";
',
    require => Package["drbd"],
    #before  => Service["drbd"],
    #notify  => Service["drbd"],
  }

  # only allow files managed by puppet in this directory.
  file { "/etc/drbd.conf.d/":
    ensure  => directory,
    source  => "puppet:///modules/drbd/drbd.conf.d/",
    mode    => "0644",
    purge   => true,
    recurse => true,
    force   => true,
    require => Package["drbd"],
    #notify  => Service["drbd"],
  }

}
