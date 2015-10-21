# == Class sentry::params
#
# This class is meant to be called from sentry.
# It sets variables according to platform.
#
class sentry::params {
  case $::osfamily {
    'Debian', 'RedHat': {
      $packages = {
        common => 'sentry',
        store => 'sentry-store',
      }
      $service_name = 'sentry-store'
    }
    default: {
      fail("${::osfamily} (${::operatingsystem}) not supported")
    }
  }

  $confdir = '/etc/sentry/conf'
  $descriptions = {}
  $homedir = '/var/lib/sentry'
}
