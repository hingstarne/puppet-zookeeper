#zookeeper

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Resources managed by zookeeper module](#resources-managed-by-zookeeper-module)
    * [Setup requirements](#setup-requirements)
    * [Beginning with module zookeeper](#beginning-with-module-zookeeper)
4. [Usage](#usage)
5. [Operating Systems Support](#operating-systems-support)
6. [Development](#development)

##Overview

This module installs, manages and configures zookeeper.

##Module Description



##Setup

###Resources managed by zookeeper module
* This module installs the zookeeper package
* Enables the zookeeper service
* Can manage all the configuration files (by default no file is changed)

###Setup Requirements
* PuppetLabs stdlib module
* PuppetLabs apt module
* Puppet version >= 2.7.x
* Facter version >= 1.6.2

###Beginning with module zookeeper

To install the package provided by the module just call the class:

        class { 'zookeeper': }

(or if you like include it, but you have been warned, there be dragons

        include zookeeper
)

The main class arguments can be provided either via Hiera (from Puppet 3.x) or direct parameters:

        class { 'zookeeper':
          parameter => value,
        }

The module provides also a generic define to manage any zookeeper configuration file:

        zookeeper::conf { 'sample.conf':
          content => '# Test',
        }


##Usage

* A common way to use this module involves the management of the main configuration file via a custom template (provided in a custom site module):

        class { 'zookeeper':
          config_file_template => 'site/zookeeper/zookeeper.conf.erb',
        }
* To build an ensemble of zookeeper server ( for solr4 for example ) just use:
        
        class { 'zookeeper':
          zoo_ensemble => ['Server1','Server2','Server3'],
        }
You can use the hostname, the fqdn or the ip address of the servers.

* You can write custom templates that use setting provided but the config_file_options_hash paramenter

        class { 'zookeeper':
          config_file_template      => 'site/zookeeper/zookeeper.conf.erb',
          config_file_options_hash  => {
            opt  => 'value',
            opt2 => 'value2',
          },
        }

* Use custom source (here an array) for main configuration file. Note that template and source arguments are alternative.

        class { 'zookeeper':
          config_file_source => [ "puppet:///modules/site/zookeeper/zookeeper.conf-${hostname}" ,
                                  "puppet:///modules/site/zookeeper/zookeeper.conf" ],
        }


* Use custom source directory for the whole configuration directory, where present.

        class { 'zookeeper':
          config_dir_source  => 'puppet:///modules/site/zookeeper/conf/',
        }

* Use custom source directory for the whole configuration directory and purge all the local files that are not on the dir.
  Note: This option can be used to be sure that the content of a directory is exactly the same you expect, but it is desctructive and may remove files.

        class { 'zookeeper':
          config_dir_source => 'puppet:///modules/site/zookeeper/conf/',
          config_dir_purge  => true, # Default: false.
        }

* Use custom source directory for the whole configuration dir and define recursing policy.

        class { 'zookeeper':
          config_dir_source    => 'puppet:///modules/site/zookeeper/conf/',
          config_dir_recursion => false, # Default: true.
        }


##Operating Systems Support

This is tested on these OS:
- Debian 6 and 7

The module is based on **stdmod** naming standards.

Refer to http://github.com/stdmod/ for complete documentation on the common parameters.


