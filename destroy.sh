#!/bin/bash

########################################
# Remove OPENSHIFT
########################################
cd ansible
ansible-playbook -vv -i ../config/inventory --tags "remove" ocp_libvirt.yaml
cd ..

########################################

































