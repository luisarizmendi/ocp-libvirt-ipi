NOTE about using a single Master
=====================

in OCP 4.4 there is a BUG that prevents the installation to complete when using one master instead of 3. You can workaround with manual steps while deploying:

https://bugzilla.redhat.com/show_bug.cgi?id=1805034


Why you will want to use this repo?
=====================

Imaging that you have a PC/Laptop (with a good amount of RAM and CPU) running Fedora or a CentOS7 server and you want to run OpenShift on them, but you don't want to use CodeReady Containers VM (because multiple reasons... but let's say that you want to test the latest bits)... well... that's the use case of this automation.

You can choose to run a full OpenShift installation (with 3 masters and 2+ nodes) or just 3 masters with no workers, or a single VM all-in-one*

*NOTE: Using OCP 4.4 there have been a change on how the ETCD cluster is managed and right now there is a BUG that is preventing all-in-one deployments, as explained in the previous section.

OpenShift libvirt IPI
=====================

The scripts will make use of libvirt IPI installation, steps are based on https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md

It will use by default 7GB of RAM and 4 vcores per node (minimum 2 nodes, so 14GB of RAM and 8 threads/cores). Bear in mind that you will need +2GB and 2 cores for bootstrap while installing. 

If you don't have enough resources to run the 3 masters 2 workers setup, you could configure just 1 master and X workers (scripts will change automatically the manifest to make it work) or even just 1 master and 0 workers (All-in-One setup), but in that case increase the default memory per node (7GB could not be enough to run everything).

This IPI installation won't need that you configure an external load balancer (although you can install it with these scritps), any HTTP server or that you configure SRV in an external DNS, you will need to configure just the api and the apps wildcard (you can always play with the /etc/hosts if you don't have a chance to configure a DNS)

You won't need to configure a Load Balancer because in the KVM an iptables rule will be configured to forward 6443 to first master and 443 and 80 to first worker. That's OK if you are thinking about using 1 master and 1 worker or a all-in-one setup (in case that you don't deploy workers, all traffic will be to first master), but if you plan to have multiple masters and workers, configuring a load balancer is a good idea.

If you want to run HA tests you will need to install a haproxy and reconfigure that rules to point to the load balancer VIP (see "other configs" section). If you are running the KVM locally, you will get HA for masters since the dnsmasq will round robin the IP bind to the dns name but not for APPS. 

One more thing to be taken into account is that due https://github.com/openshift/installer/issues/1007 we need to configure *.apps.basedomain instead of *.apps.< CLUSTERNAME >.basedomain, so bear in mind that change and do not include the cluster name when trying to access your APPs.


Deploying 
=========

All configuration needed is in `config` directory, you only have to include:

In install-config.yaml

* Pull secret
* KVM IP and bridge name (optional)
* Cluster name and Domain (if your KVM is not local you can setup a < ip >.nip.io domain if you don't have a "real" domain name)
* Public ssh key
* Number of masters (1 or 3) and workers (1 or 2... more could be configured but then there is a chance that the router won't run on the first worker node where the iptables are forwarding, in that case you better have a loadbalancer configured)

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

By default NFS storage and a storageclass for dynamic PV provisioning (no supported in Openshift, but it works for testing) will be configured. You can disable it by changing `nfs_storage` variable to `false` in the inventory. In that case ephemeral storage will be configured in the internal registry and you won't have dynamic provisioning. You could want to avoid configuring NFS if, for example, you want to install on a laptop and you don't want to install anything else (nfs = true will install and configure the NFS server on the node serving libvirt)

In the same manner, you can disable the configuration of the load balance service (default is on, so haproxy will be installed on the host) by changing `lb` to `false` in the `[kvm:vars]` section of the inventory.

Local users will be created (ie. clusteradmin / R3dhat01). You can disable it by configuring `ocp_create_users` to `false` 