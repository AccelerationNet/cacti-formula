{% from "cacti/map.jinja" import cacti with context %}

# configure snmp

snmp-packages:
  pkg.installed:
    - names: {{ cacti.snmp_packages }}

snmp-configuration:
  # enable third-party MIBs
  file.replace:
    - name: /etc/snmp/snmp.conf
    - pattern: '^mibs'
    - repl: '#mibs'
    - watch:
      - pkg: snmp-packages

  # download third-party MIBs
  cmd.wait:
    - name: download-mibs
    - watch:
      - pkg: snmp-packages
