
## Docker network via the container network interface (CNI)

What follows is to a large degree information that I found on the blog of [Jon Langemak](http://www.dasblinkenlichten.com/test/). You can find his content here:

* 2017-02-17: [Understanding CNI (Container Networking Interface)](http://www.dasblinkenlichten.com/understanding-cni-container-networking-interface/)
* 2017-02-22: [Using CNI with Docker](http://www.dasblinkenlichten.com/using-cni-docker/)
* 2017-03-06: [IPAM and DNS with CNI](http://www.dasblinkenlichten.com/ipam-dns-cni/)

### Set-up

Before we start we need to install the CNI plug-ins that we're going to use:

    ansible-playbook 20-cni.yml

Besides installing the binaries this will also create a configuration file: `/home/vagrant/cni_bridge.conf` that we will later need.

### Setting up the container and its network

Before you start the following, if you have just executed the set-up above, then please logout and login again, because the install step also did set some environment variables in `~/.bashrc` that will be read once you login again.

Let's first start a container without networking enabled:

Node1:

    docker run -d --rm -h docker1h --name docker1n --net=none net-tools
    docker exec -it docker1n /bin/bash
    > ip -d link

Now we're ready to use the `CNI bridge plugin` to set-up a local bridge network:

Node1:

    sudo -H -E CNI_COMMAND=ADD CNI_CONTAINERID=$(docker inspect docker1n | jq -r '.[0].Id') CNI_NETNS=$(docker inspect docker1n | jq -r '.[0].NetworkSettings.SandboxKey') CNI_IFNAME=eth0 CNI_PATH=/home/vagrant/bin/cni/ /home/vagrant/bin/cni/bridge < cni_bridge.conf

This should create an answer as follows on the terminal:

    {
        "cniVersion": "0.2.0",
        "ip4": {
            "ip": "10.13.23.100/24",
            "gateway": "10.13.23.99",
            "routes": [
                {
                    "dst": "0.0.0.0/0",
                    "gw": "10.13.23.99"
                },
                {
                    "dst": "1.1.1.1/32",
                    "gw": "10.13.23.1"
                }
            ]
        },
        "dns": {}
    }

At the very top you can see that the container got the IP `10.13.23.100` and we can talk to it now, e.g.

    curl 10.13.23.100

will give you the answer from the Apache httpd running in the container.

Running the ip addr and route commands gives the following output:

    root@docker1h:/# ip -d addr
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
    3: eth0@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
        link/ether 0a:58:0a:0d:17:64 brd ff:ff:ff:ff:ff:ff link-netnsid 0 promiscuity 0
        veth
        inet 10.13.23.100/24 scope global eth0
           valid_lft forever preferred_lft forever
    root@docker1h:/# ip -d route
    unicast default via 10.13.23.99 dev eth0  proto boot  scope global
    unicast 1.1.1.1 via 10.13.23.1 dev eth0  proto boot  scope global
    unicast 10.13.23.0/24 dev eth0  proto kernel  scope link  src 10.13.23.100

Running the ip addr and route on the host gives the following:

    vagrant@node1:~$ ip -d addr
    5: cni_bridge1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 0a:58:0a:0d:17:63 brd ff:ff:ff:ff:ff:ff promiscuity 0
        bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filtering 0 vlan_protocol 802.1Q
        inet 10.13.23.99/24 scope global cni_bridge1
           valid_lft forever preferred_lft forever
    6: veth6ba01a7b@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master cni_bridge1 state UP group default
        link/ether 72:1e:44:85:4b:70 brd ff:ff:ff:ff:ff:ff link-netnsid 0 promiscuity 1
        veth
        bridge_slave state forwarding priority 32 cost 2 hairpin off guard off root_block off fastleave off learning on flood on
    vagrant@node1:~$ ip -d route
    unicast default via 10.0.2.2 dev eth0  proto boot  scope global
    unicast 10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15
    unicast 10.13.23.0/24 dev cni_bridge1  proto kernel  scope link  src 10.13.23.99
    unicast 172.17.0.0/16 dev docker0  proto kernel  scope link  src 172.17.0.1 linkdown
    unicast 192.168.56.0/24 dev eth1  proto kernel  scope link  src 192.168.56.101

As you can see on the host a new bridge interface was created with the ip address `10.13.23.99`. In addition the container is linked via a `veth` pair to this bridge and the routing information has been updated accordingly inside and outside of the container. The configuration file we used to set-up this network is the following:

    vagrant@node1:~$ cat cni_bridge.conf
    {
        "cniVersion": "0.2.0",
        "name": "my_cni_bridge",
        "type": "bridge",
        "bridge": "cni_bridge1",
        "isGateway": true,
        "ipMasq": true,
        "ipam": {
            "type": "host-local",
            "subnet": "10.13.23.0/24",
            "routes": [
                { "dst": "0.0.0.0/0" },
                { "dst": "1.1.1.1/32", "gw":"10.13.23.1"}
            ],
            "rangeStart": "10.13.23.100",
            "rangeEnd": "10.13.23.200",
            "gateway": "10.13.23.99"
        }
    }

We are using the `host-local` type of `ipam` (IP address management). This will create a file structure below `/var/lib/cni/networks/my_cni_bridge` as you can see below to track the already assigned IP addresses in this network:

    root@node1:/var/lib/cni/networks/my_cni_bridge# ll
    total 16
    drwxr-xr-x 2 root root 4096 Dez  6 06:49 ./
    drwxr-xr-x 3 root root 4096 Dez  6 06:49 ../
    -rw-r--r-- 1 root root   64 Dez  6 06:49 10.13.23.100
    -rw-r--r-- 1 root root   12 Dez  6 06:49 last_reserved_ip.0

The content of the files is the container ID that got assigned the IP address:

    root@node1:/var/lib/cni/networks/my_cni_bridge# cat 10.13.23.100
    e27015fbd077b84909b3c48d867f8b132c1bec72f3db39ff3c4500264c5f2311

Obviously this `host-local` type for `ipam` will only work on one machine. For groups of machines or clusters you will need other modules that take care of `ipam`. One option would be DHCP. Another is with [calico](https://www.projectcalico.org/), that comes with its own `ipam` module backed by data in `etcd`.

You can find the standard network plugins that come with the CNI reference implementation here: https://github.com/containernetworking/plugins/tree/master/plugins/main. The standard `ipam` modules delivered with the reference implementation are here: https://github.com/containernetworking/plugins/tree/master/plugins/ipam.

If you were to use CNI with kubernetes then the configuration information like the one we provided in the file `cni_bridge.conf` would reside in the standardized location `/etc/cni/net.d` rather than handing it over manually to the CNI plugin.
