# == Class sentry::client::config
#
# This class is called from sentry::client for sentry config.
#
class sentry::client::config {
  contain sentry::common::config
}
