OpenShift libvirt IPI
=====================

These scripts will install OpenShift on a CentOS 7 or Fedora based KVM. It can be useful if you want to run OpenShift locally in your Fedora (if you don't want to use CodeReady Containers) or if you have a remote centos KVM machine.

It will use by default 7GB of RAM and 4 vcores per node (minimum 2 nodes, so 14GB of RAM and 8 threads/cores). Bear in mind that you will need +2GB and 2 cores for bootstrap while installing. 

Steps are based on https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md

This IPI installation won't need that you configure an external load balancer, any HTTP server or that you configure SRV in an external DNS, you will need to configure just the api and the apps wildcard (you can always play with the /etc/hosts if you don't have a chance to configure a DNS)

You won't need to configure a Load Balancer because in the KVM an iptables rule will be configured to forward 6443 to first master and 443 and 80 to first worker. If you want to run HA tests you will need to install a haproxy and reconfigure that rules to point to the load balancer VIP. If you are running the KVM locally, you will get HA for masters since the dnsmasq will round robin the IP bind to the dns name.

One more thing to be taken into account is that due https://github.com/openshift/installer/issues/1007 we need to configure *.apps.basedomain instead of *.apps.< CLUSTERNAME >.basedomain, so bear in mind that change and do not include the cluster name when trying to access your APPs.


Deploying 
=========

All configuration needed is in `config` directory, you only have to include:

In install-config.yaml

* Pull secret
* KVM IP and bridge name (optional)
* Cluster name and Domain (if your KVM is not local you can setup a < ip >.nip.io domain if you don't have a "real" domain name)
* Public ssh key
* Number of masters (1 or 3) and workers

In inventory

* Connection details: KVM and installer IP (could be the same one), port and ssh username
* KVM interface (`kvm_interface`)
* OCP release details: `ocp_release` (from https://mirror.openshift.com/pub/openshift-v4/clients/ocp),`ocp_git_branch` (from https://github.com/openshift/installer), `ocp_install_install_release_image_override` (from https://quay.io/repository/openshift-release-dev/ocp-release?tag=latest&tab=tags). 

Be aware that you will need to select the right values for ocp_release, ocp_git_branch and ocp_install_install_release_image_override otherwise the installation will fail. We need to override the image because of this: https://github.com/openshift/os/issues/394

Ansible will be used so you have to install ansible and you need passwordless access to the KVM node.

In order to run the install you have just to run:

`./run.sh`

If you want to run it locally (so the KVM is on the same server where you are running this script, what is easier if you don't want to deal with DNS configuration on your local machine) I recommend to run inside a TMUX session, so you don't find any issue if the ssh session drops.

Other configs 
============

The ansible playbooks will configure kvm as a previous step to the openshift install. You can skip this by changing the `kvm_install` and `kvm_configure` to `false` in the file config/inventory under the `[kvm:vars]` section.

If you have enough CPU and RAM you can change the default resources configuring `vms_memory` and `vms_vcpu` under the `[installer:vars]` section (16GB would be a nice amount of memory instead of 7GB per VM).