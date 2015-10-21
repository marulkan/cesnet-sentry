# == Class sentry::server::install
#
# Sentry store installation.
#
class sentry::server::install {
  contain sentry::common::postinstall

  package { $::sentry::packages['store']:
    ensure => present,
  }

  if $::osfamily == 'Debian' {
    # workaround Sentry packaging bug
    file { "/etc/init.d/${::sentry::service_name}":
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => "puppet:///modules/sentry/sentry-store-${::osfamily}.sh",
      before => Package[$::sentry::packages['store']],
    }
  }

  Package[$::sentry::packages['store']] -> Class['::sentry::common::postinstall']
}
