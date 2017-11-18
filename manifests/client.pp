# == Class sentry::client
#
# Sentry client.
#
class sentry::client {
  include ::sentry::client::install
  include ::sentry::client::config

  Class['sentry::client::install']
  -> Class['sentry::client::config']
  -> Class['sentry::client']
}
