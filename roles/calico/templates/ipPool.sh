#!/bin/bash
sudo ETCD_ENDPOINTS={%- for host in groups['etcd_nodes'] -%}http://{{ hostvars[host].ansible_host }}:2379{% if not loop.last %},{% endif %}{%- endfor -%}{{ ' '}} /home/vagrant/bin/calicoctl apply -f ipPool.conf
