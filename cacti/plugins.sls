{% from "cacti/map.jinja" import cacti with context %}

# configure for plugins (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=681558)

{{cacti.local_cacti_path}}/plugins/index.php:
  file.copy:
    - makedirs: True
    - source: {{cacti.path}}/site/plugins/index.php

{{cacti.path}}/site/plugins:
  file.symlink:
    - target: {{cacti.local_cacti_path}}/plugins
    - force: True

{{cacti.local_cacti_path}}/include:
  file.symlink:
    - target: {{cacti.path}}/site/include

{{cacti.local_cacti_path}}/lib:
  file.symlink:
    - target: {{cacti.path}}/site/lib
    - force: True

discovery-plugin:
  archive.extracted:
    - name: {{cacti.local_cacti_path}}/plugins/
    - if_missing: {{cacti.local_cacti_path}}/plugins/discovery
    - source: http://docs.cacti.net/_media/plugin:discovery-v1.5-1.tgz
    - source_hash: sha1=b63580d48addcfea2c970455882cf87d417b475f
    - archive_format: tar

autom8-plugin:
  archive.extracted:
    - name: {{cacti.local_cacti_path}}/plugins/
    - if_missing: {{cacti.local_cacti_path}}/plugins/autom8
    - source: http://docs.cacti.net/_media/plugin:autom8-v0.35.tgz
    - source_hash: sha1=38cdc06efe5c995d8b6ac8094a3040ecfa212998
    - archive_format: tar

autom8-plugin-fix:
  file.rename:
    - name: {{cacti.local_cacti_path}}/plugins/autom8
    - source: {{cacti.local_cacti_path}}/plugins/trunk

dpdiscover-plugin:
  archive.extracted:
    - name: {{cacti.local_cacti_path}}/plugins/
    - if_missing: {{cacti.local_cacti_path}}/plugins/dpdiscover
    - source: http://runningoffatthemouth.com/dpdiscover-latest.tgz
    - source_hash: sha1=50b7f2fdecf1de707097f05209e2c7872535ac50
    - archive_format: tar
