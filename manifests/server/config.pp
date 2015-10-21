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
}
