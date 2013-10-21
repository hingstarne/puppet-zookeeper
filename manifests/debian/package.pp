class zookeeper::debian::package (
	$debmirror               = $zookeeper::params::debmirror 
	) inherits zookeeper::params
   {
    apt::source { 'debian_unstable':
        location             => 'http://http.debian.net/debian/',
        release              => 'unstable',
        repos                => 'main contrib non-free',
        required_packages    => 'debian-keyring debian-archive-keyring',
        pin                  => '-10',
    }
}