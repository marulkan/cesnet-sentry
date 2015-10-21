# == Class sentry::client::install
#
# This class is called from sentry::client for install.
#
class sentry::client::install {
  contain sentry::common::postinstall

  package { $::sentry::packages['common']:
    ensure => present,
  }
  Package[$::sentry::packages['common']] -> Class['::sentry::common::postinstall']
}
