#
#== Class: pacemaker::config
#
#Configures pacemaker through crm
#
class pacemaker::config {
  include pacemaker::config::corosync
  include pacemaker::config::cibadmin
}
