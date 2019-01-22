# == Class sentry::server::config
#
# This class is called from sentry::server for service config.
#
class sentry::server::config {
  contain sentry::common::config

  $puppet_file = "${::sentry::homedir}/.puppet-schema-created"

  File["${::sentry::confdir}/sentry-site.xml"]
  ~>
  exec { 'sentry-schema':
    command => "sentry --command schema-tool --conffile ${::sentry::confdir}/sentry-site.xml --dbType ${::sentry::_db} --initSchema && touch ${puppet_file}",
    creates => $puppet_file,
    path    => '/sbin:/usr/sbin:/bin:/usr/bin',
    user    => 'sentry',
  }

  hadoop_lib::jdbc { '/usr/lib/sentry/lib':
    db => $::sentry::db,
  }

  if $::sentry::realm {
    if $::sentry::keytab_source {
      file { $::sentry::keytab:
        owner  => 'sentry',
        group  => 'sentry',
        mode   => '0400',
        alias  => 'sentry.service.keytab',
        source => $sentry::keytab_source,
      }
    } else {
      file { $::sentry::keytab:
        owner => 'sentry',
        group => 'sentry',
        mode  => '0400',
        alias => 'sentry.service.keytab',
      }
    }
  }
}
