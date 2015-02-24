{% from "cacti/map.jinja" import cacti with context %}


cacti-packages:
  pkg.installed:
    - names: {{ cacti.packages }}

# poll with cacti every minute
/etc/cron.d/cacti:
  file.replace:
    - pattern: '^\*/5'
    - repl: '*/1'

# enable third-party MIBs
/etc/snmp/snmp.conf:
  file.replace:
    - pattern: '^mibs'
    - repl: '#mibs'

# download third-party MIBs
download-mibs:
  cmd.wait:
    - watch:
      - pkg: cacti-packages

# custom templates for 1m interval data, graph naming, and more Cisco
/opt/cacti/templates.xml:
  file.managed:
    - source: salt://cacti/files/templates.xml
    - makedirs: True

install-templates:
  cmd.wait:
    - cwd: /usr/share/cacti/cli/
    - name: 'php -q import_template.php --filename=/opt/cacti/templates.xml --with-template-rras'
    - watch:
        - file: /opt/cacti/templates.xml

# add some files that don't come in templates.xml
/usr/share/cacti/resource/snmp_queries:
  file.recurse:
    - source: salt://cacti/files/usr/share/cacti/resource/snmp_queries/
    - clean: False
