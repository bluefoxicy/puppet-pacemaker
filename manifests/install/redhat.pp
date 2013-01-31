#
#== Class: pacemaker::install::redhat
#
# Selects if we need any flavor-specific stuff for Redhat distros
class pacemaker::install::redhat {

  case $operatingsystem {
    'Fedora': {
      include pacemaker::install::redhat::fedora
    }
    # Default assumes RHEL, SciLinux, CentOS, etc.
    default: {
      include pacemaker::install::redhat::el
    }
  }

  $pacemaker_packages =
    [
      "pacemaker.${architecture}",
      "resounce-agents.${architecture}",
    ]
  $corosync_packages  = "corosync.${architecture}"

}
