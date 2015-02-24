cacti-formula
================

Saltstack formula to install cacti.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

.. contents::
    :local:


``cacti``
---------

Installs the cacti package, spline poller, third-party MIBs, and some
cacti templates. One major change is reconfiguring for 1m interval data.

``cacti.plugins``
-----------------

Configures a local plugins folder and installs some plugins:

* `discovery` - scans networks for devices and allows adding
* `autom8` - allows configuring rules for autogenerating graphs
* `dpdiscover` - scans for devices using discovery protocols against
  existing cacti hosts

.. _discovery: http://docs.cacti.net/plugin:discovery
.. _autom8: http://docs.cacti.net/plugin:autom8
.. _dpdiscover: http://docs.cacti.net/userplugin:dpdiscover

Post-install instructions
=========================

Cacti has a few manual steps to get working. It stores it's settings
in the db, without an API to set those. Open up a browser and hit:

* ``/cacti/``

  * click through the install wizard
  * login using ``admin``/``admin`` and change your password

* ``/cacti/settings.php?tab=general``

  * set your SNMP defaults

* ``/cacti/settings.php?tab=poller``

  * Poller Type: spine
  * poller/cron interval = every minute
  * Maximum Concurrent Poller Processes: 2
  * Maximum Threads per Process: 8
  * Number of PHP Script Servers: 2
  * The Maximum SNMP OID's Per SNMP Get Request 16

* ``/cacti/settings.php?tab=visual``

  * Data Queries -> Maximum Field Length: 30
  * Data Sources -> Maximum Title Length: 60
