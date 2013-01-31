puppet-pacemaker
================

A module to configure Pacemaker

Originally was based on camptocamp/puppet-pacemaker, but at some point
I ripped out the whole thing and started over.

The general configuration sets up Corosync and Pacemaker.  After that,
defined types run crm commands to configure the node.



