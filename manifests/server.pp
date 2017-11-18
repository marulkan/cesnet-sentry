# == Class sentry::server
#
# Sentry store.
#
class sentry::server {
  include ::sentry::server::install
  include ::sentry::server::config
  include ::sentry::server::service

  Class['sentry::server::install']
  -> Class['sentry::server::config']
  ~> Class['sentry::server::service']
  -> Class['sentry::server']
}
