#
#== Class: pacemaker::install::debian
#
#Installs the pacemaker package and heartbeat high availability service. This
#class sets up heartbeat on the nodes of the cluster, then optionally loads the
#cluster configuration.
class pacemaker::install::debian {
  case $operatingsystem {
    'Debian','Ubuntu': {
      #include pacemaker::install::debian
    }
    default: {
      fail("pacemaker not implemented on $operatingsystem $osversion")
    }
  }

  $pacemaker_packages =
    [
      "pacemaker",
      "resource-agents",
    ]
  $corosync_packages  = "corosync"
}
