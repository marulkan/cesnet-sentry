# == Class sentry::common::config
#
# Configuration of Sentry generic for both server and client.
#
class sentry::common::config {
  file { "${::sentry::confdir}/sentry-site.xml":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    alias   => 'sentry-site.xml',
    content => template('sentry/sentry-site.xml.erb'),
  }
}
