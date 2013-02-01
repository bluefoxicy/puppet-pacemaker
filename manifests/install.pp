#
#== Class: pacemaker::install
#
#Installs the pacemaker package and heartbeat high availability service. This
#class sets up heartbeat on the nodes of the cluster, then optionally loads the
#cluster configuration.
class pacemaker::install {

  case $osfamily {
    'RedHat': {
      include pacemaker::install::redhat
      $pacemaker_packages = $pacemaker::install::redhat::pacemaker_package
      $corosync_packages  = $pacemaker::install::redhat::corosync_package
    }

    'Debian': {
      include pacemaker::install::debian
      $pacemaker_packages = $pacemaker::install::debian::pacemaker_package
      $corosync_packages  = $pacemaker::install::debian::corosync_package
    }

    default: {
      fail("pacemaker not implemented on $operatingsystem $lsbmajdistrelease")
    }
  }

  @package { $corosync_packages:
    ensure => present,
    tag    => 'corosync',
  }

  @package { $pacemaker_packages:
    ensure  => present,
    tag     => 'pacemaker'
  }

  Package <| tag == 'corosync' |>  ->
  Package <| tag == 'pacemaker' |>
}
