{% from "cacti/map.jinja" import packages with context %}

# configure snmp

snmp-packages:
  pkg.installed:
    - names: {{ packages.snmp }}

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
