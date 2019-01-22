# == Class: sentry
#
# Apache Sentry setup.
#
class sentry (
  $sentry_hostname = $::fqdn,
  $alternatives = '::default',
  $admin_groups = ['sentry'],
  $db = 'derby',
  $db_host = 'localhost',
  $db_user = 'sentry',
  $db_name = 'sentry',
  $db_password = undef,
  $keytab = '/etc/security/keytab/sentry.service.keytab',
  $keytab_source = undef,
  $properties = undef,
  $realm = undef,
) inherits ::sentry::params {
  include ::stdlib

  case $db {
    'derby',default: {
      $db_properties = {
        'sentry.store.jdbc.url' => "jdbc:derby:;databaseName=${::sentry::homedir}/sentry_store_db;create=true",
        'sentry.store.jdbc.driver' => 'org.apache.derby.jdbc.EmbeddedDriver',
      }
      $_db = 'derby'
    }
    'mysql','mariadb': {
      $db_properties = {
        'sentry.store.jdbc.url' => "jdbc:mysql://${db_host}/${db_name}",
        'sentry.store.jdbc.driver' => 'com.mysql.jdbc.Driver',
        'sentry.store.jdbc.user' => $db_user,
        'sentry.store.jdbc.password' => $db_password,
      }
      $_db = 'mysql'
    }
    'postgresql': {
      $db_properties = {
        'sentry.store.jdbc.url' => "jdbc:postgresql://${db_host}/${db_name}",
        'sentry.store.jdbc.driver' => 'org.postgresql.Driver',
        'sentry.store.jdbc.user' => $db_user,
        'sentry.store.jdbc.password' => $db_password,
      }
      $_db = 'postgres'
    }
    'oracle': {
      $db_properties = {
        'sentry.store.jdbc.url' => "jdbc:oracle:thin:@//${db_host}/xe",
        'sentry.store.jdbc.driver' => 'oracle.jdbc.OracleDriver',
        'sentry.store.jdbc.user' => $db_user,
        'sentry.store.jdbc.password' => $db_password,
      }
      $_db = 'oracle'
    }
  }

  if !$admin_groups or empty($admin_groups) {
    $_admin_groups = '::undef'
  } else {
    $_admin_groups = join($admin_groups, ',')
  }
  $sentry_properties = {
    all => {
      'sentry.service.allow.connect' => 'impala,hive,solr,hue',
      'sentry.hive.provider.backend' => 'org.apache.sentry.provider.db.SimpleDBProviderBackend',
    },
    client => {
      'sentry.service.client.server.rpc-address' => $sentry_hostname,
      'sentry.service.client.server.rpc-addresses' => $sentry_hostname,
      'sentry.service.client.server.rpc-connection-timeout' => 200000,
    },
    server => {
      'sentry.service.admin.group' => $_admin_groups,
      'sentry.verify.schema.version' => true,
    },
  }

  if $realm and $realm != '' {
    $sec_properties = {
      all => {
        'sentry.service.security.mode' => 'kerberos',
        'sentry.service.server.principal' => "sentry/_HOST@${realm}",
      },
      server => {
        'sentry.service.server.keytab' => $keytab,
      },
    }
  } else {
    $sec_properties = {
      all => {
        'sentry.service.security.mode' => 'none',
      },
      server => {},
    }
  }

  if $sentry_hostname == $::fqdn {
    $_properties = merge($db_properties, $sentry_properties['all'], $sentry_properties['server'], $sentry_properties['client'],  $sec_properties['all'], $sec_properties['server'], $properties)
  } else {
    $_properties = merge($sentry_properties['all'], $sentry_properties['client'],  $sec_properties['all'], $properties)
  }
}
