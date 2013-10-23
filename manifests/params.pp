# Class: zookeeper::params
#
# Defines all the variables used in the module.
#
class zookeeper::params {

  $package_name = $::osfamily ? {
    default => 'zookeeper',
  }
  $debmirror = $::osfamily ? {
    default => 'http://http.debian.net/debian/',
  }
  $service_name = $::osfamily ? {
    default => 'zookeeper',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/zookeeper/conf/zoo.conf',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/zookeeper/conf',
  }

  case $::osfamily {
    'Debian': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }
}
