
## Using calico for docker container Networking

### Set-up

You need to install `etcd` to make use of calico. Calico does not support any other storage backend than `etcd`:

    ansible-playbook 30-etcd.yml

And then you need to deploy on every node of your cluster a running calico instance and tell it where the `etcd` instance is running.

You can achieve this by running:

    ansible-playbook 31-calico.yml

This script is different than the others, because it does not install the calico agent as a service that will start automatically after a system restart. This means that you will have to execute the above playbook after every reboot of your nodes.

The reason for not installing calico as a service is that it is quite intrusive concerning the iptables rules that it installs. If you want to use your cluster for other experiments then these rules may or may not interfer. If you reboot the machine and do not start the calico agents then the iptable rules will be untouched.

### A few words about etcd

Before you start the following, if you have just executed the set-up above, then please logout and login again, because the install step also did set some environment variables in `~/.bashrc` that will be read once you login again. This is mainly about the `etcd` environment variables:

    export ETCD_ENDPOINTS=http://192.168.56.101:2379

Beware that the single `etcd` binary actually talks 2 very different protocols, protocol version 2 and protocol version 3. Whatever you do with the one protocol version will not be visible with the other protocol version, e.g. the storage spaces are separate.

You can see what is stored in `etcd` v2 via:

    ETCDCTL_API=2 etcdctl --endpoints http://192.168.56.101:2379 ls -r

And you can see what is stored in `etcd` v3 via:

   ETCDCTL_API=3 etcdctl --endpoints http://192.168.56.101:2379 get --prefix=true ""

Calico still makes use of v2. You can check that the settings for the calico agents (which are running as docker containers) are correct via:

    docker inspect calico-node | jq -r '.[0].Config.Env'

### Setting up the container and its network

Calico integrates with docker the same way as the docker overlay networks via the [Container Network Model (CNM)](https://github.com/docker/libnetwork/blob/master/docs/design.md). Therefore the steps to follow with calico are quite similar to the ones for the overlay example.

Node1:

     docker network create --driver calico --ipam-driver calico-ipam calico-net1
     docker network ls

Node2:

    docker network ls

You should see that docker now knows on both nodes about calico-net1.

As a next step we'll start our test docker container on node1:

Node1:

    docker run -d --rm -h docker1h --name docker1n --net=calico-net1 net-tools
    docker exec -it docker1n /bin/bash

Running ip addr and route inside of the container should show something like:

    root@docker1h:/# ip -d addr
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
    7: cali0@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
        link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netnsid 0 promiscuity 0
        veth
        inet 10.1.166.128/32 scope global cali0
           valid_lft forever preferred_lft forever
    root@docker1h:/# ip -d route
    unicast default via 169.254.1.1 dev cali0  proto boot  scope global
    unicast 169.254.1.1 dev cali0  proto boot  scope link

Running ip addr and route outside of the container should show something like:

    vagrant@node1:~$ ip -d addr
    8: cali17475131c48@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
        link/ether ba:69:77:da:4f:94 brd ff:ff:ff:ff:ff:ff link-netnsid 0 promiscuity 0
        veth
    vagrant@node1:~$ ip -d route
    unicast 10.1.166.128 dev cali17475131c48  proto boot  scope link
    blackhole 10.1.166.128/26  proto bird  scope global

I've removed the parts from the output that are not relevant for our example here. We see that the container got the IP address `10.1.166.128` and we can already ping it from the host where the container is running on:

    ping 10.1.166.128

Now let's start a container on node2:

Node2:

    docker run -d --rm -h docker2h --name docker2n --net=calico-net1 net-tools
    docker exec -it docker2n bash
    > ping docker1n

Is also working. Inside of the container you can even use the DNS name of the container rather than the IP address. Great :)

You can now also ping this second container from node 1, e.g. in my case I can execute `ping 10.1.104.0` on node 1 and get responses. Actually this only works, because the `31-calico.yml` playbook was applying the `/home/vagrant/calico-policy.yml` file to allow all traffic from anywhere to anywhere. See the details on [stackoverflow](https://stackoverflow.com/questions/47591469/turning-off-the-calico-felix-iptables-rules-or-allow-all-profile).

The networking part of calico works quite differently from the overlay network. The calico network is fully routed and does not rely on tunneling technology like `vxlan`. The running calico agents on every host run the [Border Gateway Protocol (BGP)](https://en.wikipedia.org/wiki/Border_Gateway_Protocol) to distribute the routing information in the cluster. This approach should make calico as fast as "normal" networks. You should do your own benchmarks, though, perhaps using the [Solarwinds](https://github.com/solarwinds)' [Container Network Performance Tool](https://github.com/solarwinds/containers/tree/master/cnpt) or similar.

Calico basically just installes one `veth` pair between the container and the surrounding host and does everything else via routing. Calico gives every host a `/26` network, so that you can have 64 containers per host. I guess this is configurable, but I did not check it. I also would not see why it would be a problem to have several smaller networks per host. But this may be useful if you have many containers per host to limit the amount of routing configuration that would need to be transported via BGP and set-up on the nodes.

How the communication mechanism between the container and the host is working in detail is quite well explained in:

* 2017-05-06: [Getting started with Calico on Kubernetes](http://www.dasblinkenlichten.com/getting-started-with-calico-on-kubernetes/)

This is also explaining the mechanism with `proxy-arp` that the inside of the container uses to communicate with the outside.

## Appendix: iptables
