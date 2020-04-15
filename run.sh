#!/bin/bash

#sudo yum install -y ansible


########################################
# INSTALL OPENSHIFT
########################################
cd ansible
ansible-playbook -vv -i ../config/inventory ocp_install.yaml
cd ..

########################################

































