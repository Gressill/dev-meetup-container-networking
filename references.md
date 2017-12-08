
# Docker and Kubernetes

* 2017-06-01: [Understanding container networking](https://www.oreilly.com/ideas/understanding-container-networking) by [Brian Anderson](https://medium.com/@branderlog) and [Lee Calcote](https://en.wikipedia.org/wiki/Lee_Calcote)([github](https://github.com/leecalcote))
* 2017-05-01: [The Tale of Two Container Networking Standards: CNM v. CNI](http://www.nuagenetworks.net/blog/container-networking-standards/) by [Harmeet Sahni](https://www.linkedin.com/in/harmeetsahni/)
  * Docker Container network Model: [CNM](https://github.com/docker/libnetwork/blob/master/docs/design.md)
  * Kubernetes Container Network Interface: [CNI](https://github.com/containernetworking/cni)
    * 2017-06-22: [Let's create a workflow for writing CNI plugins (including writing your first CNI plugin!)](http://dougbtv.com/nfvpe/2017/06/22/cni-tutorial/)
  * [Solarwinds](https://github.com/solarwinds)' [Container Network Performance Tool](https://github.com/solarwinds/containers/tree/master/cnpt)
* 2016-01-14: [Why Kubernetes doesn’t use libnetwork](http://blog.kubernetes.io/2016/01/why-Kubernetes-doesnt-use-libnetwork.html)
  * 2015-08-20: [Network Plugins definition (was "Kicking off the network SIG")](https://groups.google.com/forum/#!topic/kubernetes-sig-network/5MWRPxsURUw): We investigated writing a "bridge" CNM driver for Docker that ran CNI drivers. This turned out to be very complicated. First, the CNM and CNI models are very different, so none of the "methods" lined up. We still have the global vs. local and key-value issues discussed above. Assuming this driver would declare itself local, we have to get info about logical networks from Kubernetes.

* 2017-05-08: [Deep Dive in Docker Overlay Networks](https://www.youtube.com/watch?v=b3XDl0YsVsg) YouTube presentation by [Laurent Bernaille](https://github.com/lbernail)
  * [github](https://github.com/lbernail/dockeroverlays)
  * 2017-04-25: [Part 1](http://techblog.d2-si.eu/2017/04/25/deep-dive-into-docker-overlay-networks-part-1.html)
  * 2017-05-09: [Part 2](http://techblog.d2-si.eu/2017/05/09/deep-dive-into-docker-overlay-networks-part-2.html)
  * 2017-08-20: [Part 3](http://techblog.d2-si.eu/2017/08/20/deep-dive-into-docker-overlay-networks-part-3.html)


* [Jon Langemak](http://www.dasblinkenlichten.com/test/) on [github](https://github.com/jonlangemak)
  * 2017-02-17: [Understanding CNI (Container Networking Interface)](http://www.dasblinkenlichten.com/understanding-cni-container-networking-interface/)
  * 2017-02-22: [Using CNI with Docker](http://www.dasblinkenlichten.com/using-cni-docker/)
  * 2017-03-06: [IPAM and DNS with CNI](http://www.dasblinkenlichten.com/ipam-dns-cni/)
  * 2017-03-24: [Getting started with Kubernetes using Ansible](http://www.dasblinkenlichten.com/getting-started-kubernetes-using-ansible/)
  * 2017-03-29: [Kubernetes networking 101 – Pods](http://www.dasblinkenlichten.com/kubernetes-networking-101-pods/)
  * 2017-04-11: [Kubernetes networking 101 – Services](http://www.dasblinkenlichten.com/kubernetes-networking-101-services/)
  * 2017-04-25: [Kubernetes networking 101 – (Basic) External access into the cluster](http://www.dasblinkenlichten.com/kubernetes-networking-101-basic-external-access-into-the-cluster/)
  * 2017-05-02: [Kubernetes Networking 101 – Ingress resources](http://www.dasblinkenlichten.com/kubernetes-networking-101-ingress-resources/)
  * 2017-05-06: [Getting started with Calico on Kubernetes](http://www.dasblinkenlichten.com/getting-started-with-calico-on-kubernetes/)


# General underlying Linux features

## Overview

* [Thomas Graf](https://github.com/tgraf), [linkedin](https://www.linkedin.com/in/thomas-graf-73104547/?locale=de_DE), [covalent.io](http://covalent.io/), [cilium.io](https://www.cilium.io/)
  * 2015-08-18: [linux-kernel-networking-walkthrough](https://www.slideshare.net/ThomasGraf5/linuxcon-2015-linux-kernel-networking-walkthrough)
  * 2016-08-23: [linux-networking-explained](https://www.slideshare.net/ThomasGraf5/linux-networking-explained)
* 2017-04-03: [Container Networking Deep Dive](http://events.linuxfoundation.org/sites/events/files/slides/Container%20Networking%20Deep%20Dive.pdf) by [Gaetano Borgione](https://www.linkedin.com/in/gaetano-borgione-2392bb1/).
* 2017-10-01: [Demystifying container networking](http://blog.mbrt.it/2017-10-01-demystifying-container-networking/) by [Michele Bertasi](https://github.com/mbrt)
* 2016-04-10: [Network namespaces](https://blogs.igalia.com/dpino/2016/04/10/network-namespaces/) by [Diego Pino](https://github.com/dpino)

## vxlan, veth, bridges, namespaces, L2, L3, etc.

* "Fun with veth-devices, Linux bridges and VLANs in unnamed Linux network namespaces" by [Ralph Mönchmeyer](http://linux-blog.anracom.com/impressum/), [here](http://docplayer.org/18603064-Dr-ralph-moenchmeyer.html), [here](https://www.xing.com/profile/Ralph_Moenchmeyer)
  * 2017-10-30: [Part 1](http://linux-blog.anracom.com/2017/10/30/fun-with-veth-devices-in-unnamed-linux-network-namespaces-i/)
  * 2017-11-12: [Part 2](http://linux-blog.anracom.com/2017/11/12/fun-with-veth-devices-linux-bridges-and-vlans-in-unnamed-linux-network-namespaces-ii/)
  * 2017-11-14: [Part 3](http://linux-blog.anracom.com/2017/11/14/fun-with-veth-devices-linux-bridges-and-vlans-in-unnamed-linux-network-namespaces-iii/)
  * 2017-11-20: [Part 4](http://linux-blog.anracom.com/2017/11/20/fun-with-veth-devices-linux-bridges-and-vlans-in-unnamed-linux-network-namespaces-iv/)
  * 2017-11-21: [Part 5](http://linux-blog.anracom.com/2017/11/21/fun-with-veth-devices-linux-bridges-and-vlans-in-unnamed-linux-network-namespaces-v/)


* [Vincent Bernat](https://github.com/vincentbernat) and his [network-lab](https://github.com/vincentbernat/network-lab)
  * 2017-05-03: [VXLAN & Linux](https://vincent.bernat.im/en/blog/2017-vxlan-linux)
  * 2012-11-02: [Network virtualization with VXLAN](https://vincent.bernat.im/en/blog/2012-multicast-vxlan)
  * 2017-05-03: [VXLAN: BGP EVPN with Cumulus Quagga](https://vincent.bernat.im/en/blog/2017-vxlan-bgp-evpn)
  * 2017-04-14: [Proper isolation of a Linux bridge](https://vincent.bernat.im/en/blog/2017-linux-bridge-isolation)


* [Arun Sriraman](http://blog.arunsriraman.com/), [here](http://www.arunsriraman.com/), [github](https://github.com/sarun87)
  * 2017-02-06: [How To: Setting up a GRE or VXLAN tunnel on Linux](http://blog.arunsriraman.com/2017/02/how-to-setting-up-gre-or-vxlan-tunnel.html)
    * kernel [vxlan.txt](https://www.kernel.org/doc/Documentation/networking/vxlan.txt)
    * 2013-10-21: [Software Defined Networking using VXLAN](http://events.linuxfoundation.org/sites/events/files/slides/2013-linuxcon.pdf) by Thomas Richter
  * 2017-03-22: [Container Namespaces - How to add networking to a docker container](http://blog.arunsriraman.com/2017/03/container-namespaces-how-to-add.html)
  * 2017-01-09: [Container Namespaces - Deep dive into container networking](http://blog.arunsriraman.com/2017/01/container-namespaces-deep-dive-into.html)
  * 2016-12-18: [IP Networking - generational shift in the industry to pure-L3 network stack](http://blog.arunsriraman.com/2016/12/ip-networking-generational-shift-in.html)
    * 2015-04-21: [Rearchitecting L3-Only Networks](http://blog.ipspace.net/2015/04/rearchitecting-l3-only-networks.html) by [Ivan Pepelnjak](http://www.ipspace.net/About_Ivan_Pepelnjak), [linkedin](https://www.linkedin.com/in/ivanpepelnjak/?locale=de_DE)


* [Ivan Pepelnjak](http://www.ipspace.net/About_Ivan_Pepelnjak), [linkedin](https://www.linkedin.com/in/ivanpepelnjak/?locale=de_DE)
  * [5 ways to design your container network](https://cumulusnetworks.com/blog/5-ways-design-container-network/) by [Cumulus Networks](https://cumulusnetworks.com/)
    * [Cumulus Linux](https://cumulusnetworks.com/products/cumulus-linux/) network os
    * [facebook-voyager](https://cumulusnetworks.com/blog/facebook-voyager/) open transponder hardware contributed by Facebook, designed specifically to address the need for scalable, cost-effective backhaul infrastructure.
  * Webinar: [Leaf-and-Spine Fabric Architectures](http://www.ipspace.net/Leaf-and-Spine_Fabric_Architectures)
  * Webinar: [Docker Networking Fundamentals](http://www.ipspace.net/Docker_Networking_Fundamentals)

* 2017-06-20: [Nspawn OpenStack with OpenStack-Ansible](https://cloudnull.io/2017/06/nspawning-openstack-ansible/) by [Kevin Carter](https://www.linkedin.com/in/mrkcarter/) explains how to use macvlan. It also talks about having file-system barriers between containers.
  * 2017-06-28: [Using networkd to set-up the network](https://cloudnull.io/2017/06/networkd-for-nspawn-with-openstack-ansible/)
  * 2012-05-09: [macvlan host to guest connection](http://noyaudolive.net/2012/05/09/lxc-and-macvlan-host-to-guest-connection/)

* Container Networking Performance:
  * 2016-07-13: [Networking Containers in an Ultra-Low-Latency Environment](https://de.slideshare.net/deitcher/linuxconcontainercon-japan-2016-networking-containers-in-ultralow-latency-environments) by [Avi Deitcher](https://github.com/deitch)
    * [network-tests](https://github.com/deitch/network-tests) on github
  * 2016-05-29: [macvlan and ipvlan](https://sreeninet.wordpress.com/2016/05/29/macvlan-and-ipvlan/) by [Sreenivas Makam](https://github.com/smakam).
  * 2017-12-04: [Announcing cni-ipvlan-vpc-k8s: IPvlan overlay-free Kubernetes Networking in AWS](https://eng.lyft.com/announcing-cni-ipvlan-vpc-k8s-ipvlan-overlay-free-kubernetes-networking-in-aws-95191201476e) by [Paul Fisher](https://github.com/paulnivin)
    * project page on github: [cni-ipvlan-vpc-k8s](https://github.com/lyft/cni-ipvlan-vpc-k8s)
      * [k8s-vpcnet](https://github.com/lstoll/k8s-vpcnet)
      * [amazon-vpc-cni-k8s](https://github.com/aws/amazon-vpc-cni-k8s)
      * This particular trick of "IP unnumbered configuration" is documented in [RFC5309](https://tools.ietf.org/html/rfc5309).
  * 2015-02-14: [IPVLAN – The beginning](https://people.netfilter.org/pablo/netdev0.1/papers/IPVLAN-The-beginning.pdf) by [Mahesh Bandewar](https://www.linkedin.com/in/mahesh-bandewar-8556871/?locale=de_DE) and  [Eric Dumazet](https://www.linkedin.com/in/eric-dumazet-ba252942/) explains the reasoning behind developing ipvlan: The commonly used method to connect namespaces to the outside world without going through the forwarding set up on the host used to be the macvlan. This setup is simple and efficient except when the next-hop devices apply policies barring host to act like a layer2-switching device. This is especially problematic where the connected next-hop, e.g. switch is expecting frames from a specific mac for a given port. In a situation like this the macvlan setup does not work. The host will either have to fall-back to nonefficient forwarding methods or something else. IPvlan was designed to address this specific need along with few other mentioned in next few sections.



## Simulation and Testing

* [Mininet](http://mininet.org/)
  * [blog](http://mininet.org/blog/)
  * [Teaching Computer Networking with Mininet](http://conferences.sigcomm.org/sigcomm/2014/doc/slides/mininet-intro.pdf)
  * [OpenFlow tutorial](https://github.com/mininet/openflow-tutorial/wiki)
  * YouTube [Introduction to Mininet](https://www.youtube.com/watch?v=jmlgXaocwiE)
  * YouTube [Mininet Basics Tutorial - Essentials You Need to Know](https://www.youtube.com/watch?v=oPtVYSyN1wE)
  * [Link modeling using ns-3](https://github.com/mininet/mininet/wiki/Link-modeling-using-ns-3)
  * [POX tutorial](http://sdnhub.org/tutorials/pox/)
* [POX](https://github.com/noxrepo/pox) is a python framework
* [ns-3](https://www.nsnam.org/documentation/) is a C++ framework
* [Project Floodlight](http://www.projectfloodlight.org/) is a Java framework
  * [github](https://github.com/floodlight/floodlight)
* [Cooja](https://github.com/contiki-os/contiki/wiki/An-Introduction-to-Cooja) is a Java framework

## Network Debugging

* IPTables
  * [iptables-fundamentals](http://www.thegeekstuff.com/2011/01/iptables-fundamentals)
    * Also look at `man iptables-extensions`
  * [iptables-debugging](http://backreference.org/2010/06/11/iptables-debugging/)
    * Use `iptables-save` to see the complete picture.
    * [How to Enable IPtables TRACE Target](https://serverfault.com/a/739411): on newer Linux systems like Ubuntu 16.04 you have to execute `modprobe nf_log_ipv4` (and perhaps `sysctl net.netfilter.nf_log.2=nf_log_ipv4`; was not necessary for me) in order to see the TRACE logs in `/var/log/syslog`.
      * [more info](https://www.centos.org/forums/viewtopic.php?f=47&t=54411)
    * [Routing problem with mangle table on Ubuntu 16.04](https://forum.level1techs.com/t/routing-problem-with-mangle-table-on-ubuntu-16-04/114736/2)
      * `echo 1 > /proc/sys/net/ipv4/conf/all/log_martians`
      * `echo 2 > /proc/sys/net/ipv4/conf/tun0/rp_filter`
      * [ip-sysctl.txt](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)
  * [Controlling what logs where with rsyslog.conf](http://www.the-art-of-web.com/system/rsyslog-config/)
* [Intro to tcpdump](https://forum.ivorde.com/tcpdump-how-to-to-capture-only-icmp-ping-echo-requests-t15191.html)

## Linux Network Programming

* Monitoring and Tuning the Linux Networking Stack
  * [Receiving Data](https://blog.packagecloud.io/eng/2016/06/22/monitoring-tuning-linux-networking-stack-receiving-data/)
  * [Sending Data](https://blog.packagecloud.io/eng/2017/02/06/monitoring-tuning-linux-networking-stack-sending-data/)
* [NUSE: Network stack in USerspacE](http://libos-nuse.github.io/)
  * [github](https://github.com/libos-nuse/net-next-nuse)
  * [paper](https://people.netfilter.org/pablo/netdev0.1/papers/Library-Operating-System-with-Mainline-Linux-Network-Stack.pdf)
* Visualizsations of the Linux network flow
  * [Network data flow through kernel](https://mwiki.static.linuxfound.org/images/1/1c/Network_data_flow_through_kernel.png)
  * [Paket flow in netfilter and general networking](http://inai.de/images/nf-packet-flow.png)
