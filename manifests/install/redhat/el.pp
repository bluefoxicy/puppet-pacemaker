#
#== Class: pacemaker::install::redhat
#
# Installs a repo if necessary
class pacemaker::install::redhat::el {
  # For RH5 there is no Corosync/Pacemaker in EPEL
  if ( $lsbmajdistrelease in [ '4', '5'] {
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
      require => Yumrepo['clusterlabs'],
    }
 
  }
  elsif ( $lsbmajdistrelease < 4 ) {
    fail("pacemaker not implemented on $operatingsystem $lsbmajdistrelease")
  }
}

