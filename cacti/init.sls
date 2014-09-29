{% from "cacti/map.jinja" import cacti with context %}

cacti:
  pkg:
  - installed
  - name: {{ cacti.pkg }}
