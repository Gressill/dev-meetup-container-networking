#!/bin/bash

ctn=${1:-docker1n}
echo "ctn: $ctn"
ip=${2:-2}
echo "ip: $ip"

ctn_ns_path=$(docker inspect --format="{{ .NetworkSettings.SandboxKey}}" $ctn)
echo "ctn_ns_path: $ctn_ns_path"
ctn_ns=${ctn_ns_path##*/}
echo "ctn_ns: $ctn_ns"

# create veth interfaces
sudo ip link add dev veth1 mtu 1450 type veth peer name veth2 mtu 1450

# attach first peer to the bridge in our overlay namespace
sudo ip link set dev veth1 netns overns
sudo ip netns exec overns ip link set veth1 master br0
sudo ip netns exec overns ip link set veth1 up

# move second peer to container network namespace and configure it
sudo ip link set dev veth2 netns $ctn_ns_path
sudo nsenter --net=$ctn_ns_path ip link set dev veth2 name eth0 address 02:42:c0:a8:00:0${ip}
sudo nsenter --net=$ctn_ns_path ip addr add dev eth0 10.13.19.${ip}/24
sudo nsenter --net=$ctn_ns_path ip link set dev eth0 up
