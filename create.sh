#!/bin/bash

#sudo yum install -y ansible


########################################
# INSTALL OPENSHIFT
########################################
cd ansible
ansible-playbook -vv -i ../config/inventory --tags "install" ocp_libvirt.yaml
cd ..

########################################

































