## Apache Sentry Puppet Module

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with sentry](#setup)
    * [What sentry affects](#what-sentry-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with sentry](#beginning-with-sentry)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Basic Usage](#usage-basic)
    * [Sentry with MySQL](#usage-mysql)
    * [Sentry with PostgreSQL](#usage-postgresql)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Module parameters (spark class)](#parameters)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description

This puppet module installs and setup Apache Sentry - system for enforcing fine grained role based authorization to data and metadata stored on a Hadoop cluster.

<a name="setup"></a>
## Setup

### What sentry affects

* Alternatives:
 * *sentry-conf*
* Files:
 * */etc/sentry/conf/sentry-site.xml*
 * JDBC jars in */usr/lib/sentry/lib* (if needed)
 * startup skript: workaround for packaging error (tested with Cloudera CDH 5.4.7)
* Packages: *sentry*, *sentry-store*
* Services: *sentry-store*

### Setup Requirements

* repositories set
* Java JRE installed
* Hadoop cluster with enabled Kerberos security
* for Hive: security enabled (Hive Server 2: LDAP or Kerberos, Hive Metastore: Kerberos)
* for Impala: security enabled (Kerberos or LDAP)

<a name="usage"></a>
## Usage

<a name="usage-basic"></a>
### Basic usage

    include ::sentry
    include ::sentry::client
    include ::sentry::server

<a name="usage-mysql"></a>
### Sentry with MySQL

    class{'::sentry':
      db          => 'mysql',
      db_password => 'sentrypassword',
    }

    node default {
      include ::sentry::client
      include ::sentry::server

      class { 'mysql::server':
        root_password  => 'strongpassword',
      }

      mysql::db { 'sentry':
        user     => 'sentry',
        password => 'sentrypassword',
        host     => 'localhost',
        grant    => ['ALTER', 'CREATE', 'SELECT', 'INSERT', 'UPDATE', 'DELETE'],
      }

      class { 'mysql::bindings':
        java_enable => true,
      }

      Mysql::Db['sentry'] -> Class['::sentry::server::config']
      Class['mysql::bindings'] -> Class['::sentry::server::config']
    }

<a name="usage-postgresql"></a>
### Sentry with PostgreSQL

    class{'::sentry':
      db          => 'postgresql',
      db_password => 'sentrypassword',
    }

    node default {
      include ::sentry::client
      include ::sentry::server

      class { 'postgresql::server':
        postgres_password  => 'strongpassword',
      }

      postgresql::server::db { 'sentry':
        user     => 'sentry',
        password => postgresql_password('sentry', 'sentrypassword'),
      }

      include postgresql::lib::java

      Postgresql::Server::Db['sentry'] -> Class['::sentry::server::config']
      Class['postgresql::lib::java'] -> Class['::sentry::server::config']
    }

<a name="reference"></a>
## Reference

* [**``sentry``**](#class-sentry): Apache Sentry setup
* **`sentry::client`**: Sentry client
* **`sentry::server`**: Sentry store

<a name="class-sentry"></a>
<a name="parameters"></a>
### `sentry` class

Apache Sentry Setup.

####`alternatives`

Switches the alternatives used for the configuration. Default: 'cluster' (Debian) or undef.

Use it only when supported (for example with Cloudera distribution).

####`admin_groups`

List of groups allowed to make policy updates. Default: ['sentry'].

####`db`

Database for the sentry store service. Default: undef.

The default is embedded database (*derby*).

Values:

* *derby*: embedded database
* *mysql*: MySQL/MariaDB,
* *postgresql*: PostgreSQL
* *oracle*: Oracle

####`db_host`

Database hostname for *mysql*, *postgresql*, and *oracle*. Default: 'localhost'.

It can be overridden by *sentry.store.jdbc.url* property.

####`db_name`

Database name for *mysql* and *postgresql*. Default: 'sentry'.

For *oracle* 'xe' schema is used. Can be overridden by *sentry.store.jdbc.url* property.

####`db_user`

Database user for *mysql*, *postgresql*, and *oracle*. Default: 'sentry'.

It can be overridden by *sentry.store.jdbc.user* property.

####`db_password`

Database password for *mysql*, *postgresql*, and *oracle*. Default: undef.

It can be overriden by *sentry.store.jdbc.password* property.

####`properties`

Additional properties for sentry. Default: undef.

"::undef" property value will remove given property set automatically by this module, empty string sets the empty value.

<a name="limitations"></a>
## Limitations

Not supported yet:

* security
* web interface

<a name="development"></a>
##Development

* Repository: [https://github.com/MetaCenterCloudPuppet/cesnet-sentry](https://github.com/MetaCenterCloudPuppet/cesnet-sentry)
* Tests:
 * basic: see *.travis.yml*
* Email: František Dvořák &lt;valtri@civ.zcu.cz&gt;
