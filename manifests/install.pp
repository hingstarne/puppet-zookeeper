#
# = Class: zookeeper::install
#
# This class installs zookeeper
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class zookeeper::install (
  $ensure                    = 'present',
  $package_name              = $zookeeper::params::package_name,

  ) inherits zookeeper::params {
    case $::osfamily {
    'Debian': { 
     
    class { 'zookeeper::debian::package':

    ensure                   => $ensure, 
    package_name             => $package_name,
     
    }
    
    default: {
      
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    
    }


}

