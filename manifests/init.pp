# == Class: sentry
#
# Apache Sentry Setup.
#
class sentry (
  $alternatives = '::default',
  $db = 'derby',
  $db_host = 'localhost',
  $db_user = 'sentry',
  $db_name = 'sentry',
  $db_password = undef,
  $properties = undef,
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

  $sentry_properties = {
    #'datanucleus.autoCreateSchema' => false,
    #'datanucleus.autoCreateTables' => true,
    #'datanucleus.fixedDatastore' => true,
    'sentry.service.security.mode' => 'none',
    'sentry.service.admin.group' => 'admin1',
    'sentry.service.allow.connect' => 'impala,hive,solr',
    'sentry.verify.schema.version' => true,
  }

  $_properties = merge($db_properties, $sentry_properties, $properties)
}
