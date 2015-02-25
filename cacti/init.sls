{% from "cacti/map.jinja" import cacti with context %}

include:
  - .snmp


cacti-webserver:
  # install a web server first, or apache will be installed by apt
  pkg.installed:
    - names: ['nginx', 'php5-fpm']
  # remove the default config
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: cacti-webserver

cacti-debconf-pass:
  # tell cacti not to configure itself for a web server
  debconf.set:
    - name: cacti
    - data:
        'cacti/webserver': {'type': 'select', 'value': 'None'}

cacti-packages:
  # install the cacti packages
  pkg.installed:
    - names: {{ cacti.cacti_packages }}
    - require:
      - pkg: cacti-webserver
      - debconf: cacti-debconf-pass

cacti-web-config:
  # configure nginx
  file.managed:
    - name: /etc/nginx/sites-enabled/cacti
    - source: salt://cacti/files/etc/nginx/sites-enabled/cacti
    - template: jinja
    - require:
      - pkg: cacti-webserver
  # restart nginx as needed
  service.running:
    - name: nginx
    - require:
        - pkg: cacti-webserver
    - watch:
        - file: cacti-web*

# poll with cacti every minute
/etc/cron.d/cacti:
  file.replace:
    - pattern: '^\*/5'
    - repl: '*/1'
    - require:
        - pkg: cacti-packages

# serve cacti at the root of the site (`/`)
/etc/cacti/debian.php:
  file.replace:
    - pattern: '^//\$url_path.*'
    - repl: '$url_path = "";'
    - require:
        - pkg: cacti-packages

# custom templates for 1m interval data, graph naming, and more Cisco
{{cacti.local_cacti_path}}/templates.xml:
  file.managed:
    - source: salt://cacti/files/templates.xml
    - makedirs: True

install-templates:
  # install templates into cacti's db
  cmd.wait:
    - cwd: /usr/share/cacti/cli/
    - name: 'php -q import_template.php --filename={{cacti.local_cacti_path}}/templates.xml --with-template-rras'
    - watch:
        - file: {{cacti.local_cacti_path}}/templates.xml

  # add some files that don't come in templates.xml
  file.recurse:
    - name: {{cacti.path}}/resource/snmp_queries
    - source: salt://cacti/files/usr/share/cacti/resource/snmp_queries/
    - clean: False
    - require:
        - pkg: cacti-packages
