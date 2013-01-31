#
#== Class: pacemaker::install::redhat
#
# Installs a repo if necessary
class pacemaker::install::redhat::el {
  # For FC16 and prior there is no Corosync/Pacemaker
  # But there is a repo for 16 only
  if ( $lsbmajdistrelease == 16 ) {
    yumrepo { 'clusterlabs':
      descr => "High Availability/Clustering server technologies (RHEL_${lsbmajdistrelease})",
      baseurl => "http://www.clusterlabs.org/rpm/epel-${lsbmajdistrelease}/",
      enabled => 1,
      gpgcheck => 0,
    }

    # ensure file is managed in case we want to purge /etc/yum.repos.d/
    # http://projects.puppetlabs.com/issues/3152
    file { "/etc/yum.repos.d/clusterlabs.repo":
      ensure  => present,
      mode    => 0644,
      owner   => "root",
      require => Yumrepo["server_ha-clustering"],
    }
  }
  elsif ( $lsbmajdistrelease < 16 ) {
    fail("Pacemaker does not support Fedora Core $lsbmajdistrelease.")
  }
}

