#
# = Class: zookeeper
#
# This class installs and manages zookeeper
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class zookeeper (

  $ensure                    = 'present',
  $version                   = undef,

  $package_name              = $zookeeper::params::package_name,

  $service_name              = $zookeeper::params::service_name,
  $service_ensure            = 'running',
  $service_enable            = true,

  $config_file_path          = $zookeeper::params::config_file_path,
  $config_file_replace       = $zookeeper::params::config_file_replace,
  $config_file_require       = 'Package[zookeeper]',
  $config_file_notify        = 'Service[zookeeper]',
  $config_file_source        = undef,
  $config_file_template      = "zookeeper/zoo.erb",
  $config_file_content       = undef,
  $config_file_options_hash  = undef,

  $config_dir_path           = $zookeeper::params::config_dir_path,
  $config_dir_source         = undef,
  $config_dir_purge          = false,
  $config_dir_recurse        = true,

  $dependency_class          = undef,
  $my_class                  = undef,

  $monitor_class             = undef,
  $monitor_options_hash      = { } ,

  $firewall_class            = undef,
  $firewall_options_hash     = { } ,

  $scope_hash_filter         = '(uptime.*|timestamp)',

  $tcp_port                  = undef,
  $udp_port                  = undef,

  $zoo_ticktime              = $zookeeper::params::zoo_ticktime,
  $zoo_initlimit             = $zookeeper::params::zoo_initlimit,
  $zoo_synclimit             = $zookeeper::params::zoo_synclimit,
  $zoo_datadir               = $zookeeper::params::zoo_datadir,
  $zoo_clientport            = $zookeeper::params::zoo_clientport,
  $zoo_snapretain            = $zookeeper::params::zoo_snapretain,
  $zoo_purgeinterval         = $zookeeper::params::zoo_purgeinterval,
  $zoo_ensemble              = undef,

  ) inherits zookeeper::params {


  # Class variables validation and management
  if $zoo_ensemble { 

    file {"${zoo_datadir}/myid":
    ensure                   => present,
    content                  => template($config_file_template),

    }
  }
  validate_re($ensure, ['present','absent','latest'], 'Valid values: present, absent, latest.')
  validate_bool($service_enable)
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }
  if $monitor_options_hash { validate_hash($monitor_options_hash) }
  if $firewall_options_hash { validate_hash($firewall_options_hash) }

  $config_file_owner          = $zookeeper::params::config_file_owner
  $config_file_group          = $zookeeper::params::config_file_group
  $config_file_mode           = $zookeeper::params::config_file_mode

  if $config_file_content {
    $manage_config_file_content = $config_file_content
  } else {
    if $config_file_template {
      $manage_config_file_content = template($config_file_template)
    } else {
      $manage_config_file_content = undef
    }
  }

  if $config_file_notify {
    $manage_config_file_notify = $config_file_notify
  } else {
    $manage_config_file_notify = undef
  }

  if $version {
    $manage_package_ensure = $version
  } else {
    $manage_package_ensure = $ensure
  }

  if $ensure == 'absent' {
    $manage_service_enable = undef
    $manage_service_ensure = stopped
    $config_dir_ensure = absent
    $config_file_ensure = absent
  } else {
    $manage_service_enable = $service_enable
    $manage_service_ensure = $service_ensure
    $config_dir_ensure = directory
    $config_file_ensure = present
  }


  # Resources managed

  if $zookeeper::package_name {
    case $::osfamily {
    'Debian': { 
       
       class { 'zookeeper::debian::package':

       ensure                   => $ensure, 
       package_name             => $package_name,
     
      }
    }
    
    default: {

      package { $zookeeper::package_name:
      ensure   => $zookeeper::manage_package_ensure,
    
        }
      }
    }
  }
  if $zookeeper::service_name {
    service { $zookeeper::service_name:
      ensure     => $zookeeper::manage_service_ensure,
      enable     => $zookeeper::manage_service_enable,
    }
  }

  if $zookeeper::config_file_path {
    file { 'zookeeper.conf':
      ensure  => $zookeeper::config_file_ensure,
      path    => $zookeeper::config_file_path,
      mode    => $zookeeper::config_file_mode,
      owner   => $zookeeper::config_file_owner,
      group   => $zookeeper::config_file_group,
      source  => $zookeeper::config_file_source,
      content => $zookeeper::manage_config_file_content,
      notify  => $zookeeper::manage_config_file_notify,
      require => $zookeeper::config_file_require,
    }
  }

  if $zookeeper::config_dir_source {
    file { 'zookeeper.dir':
      ensure  => $zookeeper::config_dir_ensure,
      path    => $zookeeper::config_dir_path,
      source  => $zookeeper::config_dir_source,
      recurse => $zookeeper::config_dir_recurse,
      purge   => $zookeeper::config_dir_purge,
      force   => $zookeeper::config_dir_purge,
      notify  => $zookeeper::config_file_notify,
      require => $zookeeper::config_file_require,
    }
  }


  # Extra classes

  if $zookeeper::install {
    
    include $zookeeper::install
  
  }

}

