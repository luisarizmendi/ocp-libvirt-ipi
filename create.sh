#!/bin/bash

echo ""
echo "Starting at $(date +%R)"
echo ""

sdate=$(date +%s)



#sudo yum install -y ansible


########################################
# INSTALL OPENSHIFT
########################################
cd ansible
ansible-playbook -vv -i ../config/inventory --tags "install" ocp_libvirt.yaml
cd ..

########################################




cdate=$(date +%s)
duration=$(( $(($cdate-$sdate)) / 60))

echo ""
echo "Duration (mins): $duration"
echo ""





























