
## Docker network via the container network interface (CNI)

What follows is to a large degree information that I found on the blog of [Jon Langemak](http://www.dasblinkenlichten.com/test/). You can find his content here:

* 2017-02-17: [Understanding CNI (Container Networking Interface)](http://www.dasblinkenlichten.com/understanding-cni-container-networking-interface/)
* 2017-02-22: [Using CNI with Docker](http://www.dasblinkenlichten.com/using-cni-docker/)
* 2017-03-06: [IPAM and DNS with CNI](http://www.dasblinkenlichten.com/ipam-dns-cni/)

### Set-up

Before we start we need to install the CNI plug-ins that we're going to use:

    ansible-playbook 20-cni.yml

Besides installing the binaries this will also create a configuration file: `/home/vagrant/cni_bridge.conf` that we will later need.
