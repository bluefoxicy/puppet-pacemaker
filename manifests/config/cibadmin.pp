#
#== Class: pacemaker::config::cibadmin
#
#Configures pacemaker through cibadmin
#
class pacemaker::config::cibadmin {
  $cib_config          = $pacemaker::cib_config
  $config_hash         = $pacemaker::config_hash

  exec { 'dump cib config':
    command     => "cibadmin -Q | sed -e 's/^<cib.*>/<cib>/' | awk '/<status>/{s=1; next} /<\/status>/{s=0; next} s==1{next} {print}' > /etc/corosync/cib.xml",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    tag         => 'pre-cibadmin',
  }

  file { '/etc/corosync/cib.xml':
    content     => template($cib_config),
    owner       => 'root',
    group       => 'root',
    mode        => '0600',
    tag         => 'cibadmin',
  }

  exec { 'load cib config':
    command     => 'cibadmin -c -M -x /etc/corosync/cib.xml',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
    tag         => 'post-cibadmin',
  }

  Package <| tag == 'pacemaker' |>   ->
  Exec <| tag == 'pre-cibadmin' |>   ->
  File <| tag == 'cibadmin' |>       ~>
  Exec <| tag == 'post-cibadmin' |>

  Service <| tag == 'pacemaker' |>   ->
  Exec <| tag == 'pre-cibadmin' |>
}
