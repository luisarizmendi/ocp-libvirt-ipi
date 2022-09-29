# What is this repo doing?

This repo automates the usage of the [ocp-libvirt-ipi Ansible role](https://github.com/luisarizmendi/ocp-libvirt-ipi-role) that is [published in Ansible Galaxy](https://galaxy.ansible.com/luisarizmendi/ocp_libvirt_ipi_role).


# How can I use it?

You need to complete the pre-requisites and launch the script...easy.

## Pre-requisites

* You need to have your system ready to use ansible, so ansible installed, password-less access to the node and a user with sudo privileges

* You need to create a `inventory` file. There is already an inventory.EXAMPLE that you can use as a template

* You need to create a `install-config.yaml` file with the OpenShift configuration. You can find an install-config.EXAMPLE that can used as a template

* You need to create a playbook to import the role and including the variables to customize your environment. A ocp_libvirt_ipi.yaml.EXAMPLE is included to be used as template. For more information about variables you can check the [ansible role README](https://github.com/luisarizmendi/ocp-libvirt-ipi-role)

### Fedora 34 ###
If you want to install on Fedora 34 checkout [libvirt-ansible-role-fedora34-branch](https://github.com/eartvit/ocp-libvirt-ipi-role/tree/fedora34 "ansible role fedora34 branch") for the ansible role and also the [fedora34-branch](https://github.com/eartvit/ocp-libvirt-ipi/tree/fedora34 "fedora34 branch") for specifics.

## Creating or destroying the OpenShift environment

Once you completed the pre-requisites, just run `./create.sh` to deploy OpenShift or `./destroy.sh` to clean up the node.


# Enjoy

That's all, make responsible use of these playbooks (remember that this is just for LABs) and enjoy the Machine API even when your LAB is running on a single KVM node.