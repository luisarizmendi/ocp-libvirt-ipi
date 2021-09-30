#!/bin/bash


echo ""
echo "Starting at $(date +%R)"
echo ""

sdate=$(date +%s)



#sudo yum install -y ansible


########################################
# INSTALL OPENSHIFT
########################################

dnf install -y python3-netaddr

# ansible-galaxy install luisarizmendi.ocp_libvirt_ipi_role --force
# see fedora34 branch details of the libvirt IPI ansible role here: https://github.com/eartvit/ocp-libvirt-ipi-role/tree/fedora34

ansible-playbook -vv -i inventory --tags install ocp_libvirt_ipi.yaml -e "kvm_workdir=<full_path_folder_where_kvm_should_store_files> ansible_become_pass=\'your_sudo_password\'"

########################################




cdate=$(date +%s)
duration=$(( $(($cdate-$sdate)) / 60))

echo ""
echo "Duration (mins): $duration"
echo ""
