{% from "cacti/map.jinja" import packages,cacti with context %}

include:
  - cacti

# configure for plugins (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=681558)

{{packages.local_path}}/plugins/index.php:
  file.copy:
    - makedirs: True
    - source: {{packages.path}}/site/plugins/index.php
    - require:
        - pkg: cacti-packages

{{packages.path}}/site/plugins:
  file.symlink:
    - target: {{packages.local_path}}/plugins
    - force: True
    - require:
        - pkg: cacti-packages

{{packages.local_path}}/include:
  file.symlink:
    - target: {{packages.path}}/site/include
    - require:
        - pkg: cacti-packages

{{packages.local_path}}/lib:
  file.symlink:
    - target: {{packages.path}}/site/lib
    - force: True
    - require:
        - pkg: cacti-packages

{% if cacti.plugins  %}
install-git:
  pkg.installed:
    - name : git-core

{% for name,uri in cacti.plugins.items() %}
plugin {{name}}:
  git.latest:
    - name: {{uri}}
    - target: {{packages.local_path}}/plugins/{{name}}
    - require:
        - pkg: install-git
{% endfor %}

{% endif %}

discovery-plugin:
  archive.extracted:
    - name: {{packages.local_path}}/plugins/
    - if_missing: {{packages.local_path}}/plugins/discovery
    - source: http://docs.cacti.net/_media/plugin:discovery-v1.5-1.tgz
    - source_hash: sha1=b63580d48addcfea2c970455882cf87d417b475f
    - archive_format: tar

autom8-plugin:
  archive.extracted:
    - name: {{packages.local_path}}/plugins/
    - if_missing: {{packages.local_path}}/plugins/autom8
    - source: http://docs.cacti.net/_media/plugin:autom8-v0.35.tgz
    - source_hash: sha1=38cdc06efe5c995d8b6ac8094a3040ecfa212998
    - archive_format: tar

autom8-plugin-fix:
  file.rename:
    - name: {{packages.local_path}}/plugins/autom8
    - source: {{packages.local_path}}/plugins/trunk

dpdiscover-plugin:
  archive.extracted:
    - name: {{packages.local_path}}/plugins/
    - if_missing: {{packages.local_path}}/plugins/dpdiscover
    - source: http://runningoffatthemouth.com/dpdiscover-latest.tgz
    - source_hash: sha1=50b7f2fdecf1de707097f05209e2c7872535ac50
    - archive_format: tar
