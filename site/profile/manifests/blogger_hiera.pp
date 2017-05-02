

class profiles::blogger (

  $db_password  = hiera('profiles::blogger::db_password'),
  $db_user      = hiera('profiles::blogger::db_user'),
  $docroot      = hiera('profiles::blogger::docroot'),
  $wp_group     = hiera('profiles::blogger::wp_group'),
  $wp_owner     = hiera('profiles::blogger::wp_owner'),

  )
  host { 'blogger':
    ensure => present,
    ip     => $::ipaddress,
  }

  user { 'wordpress':
    ensure => present,
    name   => $wp_owner,
    gid    => $wp_group,
  }

  group { 'wordpress':
    ensure => present,
    name   => $wp_group,
  }

  include ::apache
  include ::apache::mod::php

  apache::vhost { 'blogger':
    docroot => $docroot,
    docroot_group => $wp_group,
    docroot_owner => $wp_owner,
    port    => '80',
  }

  include ::mysql::server
  class { '::mysql::bindings':
    php_enable => true,
  }

  class { 'wordpress':
    db_password => $db_password,
    db_user     => $db_user,
    wp_group    => $wp_group,
    wp_owner    => $wp_owner,
    install_dir => $docroot,
    require     => [Apache::Vhost['blogger'],Class['::mysql::server']],
  }
}
