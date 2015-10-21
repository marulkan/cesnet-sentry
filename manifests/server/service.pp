# == Class sentry::server::service
#
# This class ensures the service is running.
#
class sentry::server::service {
  ## install a package with the service here due to bug in Debian packaging system
  #package { $::sentry::packages['store']:
  #  ensure => present,
  #}
  #->
  service { $::sentry::service_name:
    ensure => running,
    enable => true,
  }
}
