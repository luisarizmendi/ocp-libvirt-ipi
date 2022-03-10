#!/bin/bash


echo ""
echo "Starting at $(date +%R)"
echo ""

sdate=$(date +%s)



#sudo yum install -y ansible


########################################
# INSTALL OPENSHIFT
########################################

dnf install -y ansible python3-netaddr

ansible-galaxy collection install ansible.netcommon

ansible-galaxy install luisarizmendi.ocp_libvirt_ipi_role --force

ansible-playbook -vv -i inventory --tags install ocp_libvirt_ipi.yaml

########################################




cdate=$(date +%s)
duration=$(( $(($cdate-$sdate)) / 60))

echo ""
echo "Duration (mins): $duration"
echo ""
