class zookeeper::debian::package (
  
  $debmirror                 = $zookeeper::params::debmirror,
  $ensure                    = 'present',
  $package_name              = $zookeeper::params::package_name, 
  
  ) inherits zookeeper::params

   {
    
    apt::source { 'debian_unstable':
    
    location             => $debmirror,
    release              => 'unstable',
    repos                => 'main contrib non-free',
    required_packages    => 'debian-keyring debian-archive-keyring',
    pin                  => '-10',
    
    }

    package { $package_name:
    
    ensure                   => $ensure,
    provider                 => "aptitude",
    require                  => Apt::Source ['debian_unstable'],
    install_options          => "-t unstable";
    
    }
}