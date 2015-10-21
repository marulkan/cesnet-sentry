# == Class sentry::common::postinstall
#
# Preparation steps after installation. It switches sentry-conf alternative, if enabled.
#
class sentry::common::postinstall {
  ::hadoop_lib::postinstall{ 'sentry':
    alternatives => $::sentry::alternatives,
  }
}
