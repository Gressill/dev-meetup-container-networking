# DevMeetup Container Networking Deep Dive

## Getting started

The below instructions will even work behind a corporate firewall as long as you have access to a corporate proxy server. You only have to set-up the `http_proxy` environment variable, but with IP address and not with DNS names:

    export http_proxy=http://aaa.bbb.ccc.ddd:pppp

If you're not behind a corporate firewall then there is nothing else to do for you.

In order to follow the below examples you will need to install the following (the exact versions should not matter too much):
* [Virtualbox](https://www.virtualbox.org/) (5.2.2)
* [Vagrant](https://www.vagrantup.com/) (2.0.1)
* [ansible](http://docs.ansible.com/) (ansible 2.4.1.0)

As ansible is currently not working on Windows hosts you either need to work on an underlying Linux machine or set-up a separate ansible control VM to execute the ansible scripts.

Virtualbox can be installed via the instructions on the web-site. There are packages for all kinds of package managers available on the download site.

Vagrant I've installed via the [Unofficial deb repository for Vagrant](https://github.com/wolfgang42/vagrant-deb) (here is the repository: [vagrant-deb.linestarve.com](https://vagrant-deb.linestarve.com/)). But you can also install it directly from the web-site.

Ansible will work on any Linux machine that has python installed. While ansible is claiming that it works now with python3 I've found some (few) compatibility issues, but which you can work around. I am using ansible on python3 installed via [anaconda](https://www.anaconda.com/download), so that I do not have to use the `pip` package manager as root. But you can use the default python installation on your machine, too. Installing ansible itself is as easy as:

    > pip install ansible

After that you're ready to go.

### Set-up the 2-node "cluster"

Download or clone this repository from [github](https://github.com/cs224/dev-meetup-container-networking). Then `cd` into this directory.

The first step is to set-up the 2-node "cluster" via Vagrant. Just execute in the current directory where the `Vagrant` file is located the following command:

    vagrant up

If you want to get rid off all of the installed and downloaded software afterwards it is as easy as:

    vagrant destroy -f

The whole process will not do anything to your local machine.

After starting the 2-node cluster try to login. At the top of the Vagrant file you can see a comment with instructions:

    # ssh-add ~/.vagrant.d/insecure_private_key
    # ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@192.168.56.101

The first node will get IP address `192.168.56.101` and the second node will get IP address `192.168.56.102`. You will only have to add once the ssh key and afterwards you can login without password. I suggest you login into both nodes before you continue. Sometimes the booting process takes a bit longer and the next steps will fail if the ssh login does not work.

The next step is to install the base system via:

    ansible-playbook 10-setup.yml

This will take some minutes, mostly depending on your speed of your internet connection.

Next you will have to install [consul](https://www.consul.io) and create the docker overlay set-up:

    ansible-playbook 11-consul.yml
    ansible-playbook 12-docker-overlay-setup.yml

Docker in the past required a key value store like `consul` or `etcd` for its overlay network set-up, but in current versions this is not required any longer. This is still supported and we use it to gain some transparency into the data-structures docker uses do manage the network infrastructure in the cluster. We mainly profit from the [consul web ui](https://www.consul.io/intro/getting-started/ui.html) that is part of the `consul` binary itself. Otherwise we could have also used `etcd`

After that you should reboot the cluster:

    vagrant halt
    vagrant up

And after logging in to both nodes check that systemd started without problems:

    systemctl status
    systemctl --failed

Now your cluster is ready for our first experiments.

The set-up created 2 scripts in the `~vagrant` home directory:

* proxy_external.sh
* proxy_local.sh

You can execute:

    source proxy_external.sh

To set the `http_proxy` and other environment variables if you want to use a command line tool that relies on these variables and you're behind a corporate proxy. The script `proxy_local.sh` does the same, but uses the locally installed and running instance of `tinyproxy` that is configured to do local requests locally and remote requests remotely.

## Deep Dive in Docker Overlay Networks

This example is following relatively closely the presentation given by [Laurent Bernaille](https://github.com/lbernail). He also published a 3 part blog post series describing his presentation:

* 2017-05-08: [Deep Dive in Docker Overlay Networks](https://www.youtube.com/watch?v=b3XDl0YsVsg) YouTube presentation by
  * [github](https://github.com/lbernail/dockeroverlays)
  * 2017-04-25: [Part 1](http://techblog.d2-si.eu/2017/04/25/deep-dive-into-docker-overlay-networks-part-1.html)
  * 2017-05-09: [Part 2](http://techblog.d2-si.eu/2017/05/09/deep-dive-into-docker-overlay-networks-part-2.html)
  * 2017-08-20: [Part 3](http://techblog.d2-si.eu/2017/08/20/deep-dive-into-docker-overlay-networks-part-3.html)

I deviate from his presentation where I feel that it makes the whole topic more clear and I mix his approach with approaches from other people. You can find a full list of high value references in the separate [references](./references.md) page.

### Creating the test docker image

In order to test our set-up we'll use a test docker image that you create by typing `make` in the `dev-meetup-container-networking` directory. If you're behind a coporate proxy you need to first execute `source proxy_external.sh` and then execute `make`. This will also create a saved docker image with the file name `net-tools.tar` in the local directory. Have a look in the `./docker-net-tools-image/Dockerfile` to see what the image does. The main purpose is to run an apache httpd that you can talk to on port 80 and the image also comes with several tools that help you to examine the network set-up inside of the container.

#### Import the test docker image in each node instance

In each node of the cluster execute the following:

    docker load -i /vagrant/net-tools.tar

This works, because vagrant is mounting the current directory of the external machine to `/vagrant` and the saved `net-tools.tar` from the previous step is accessible inside of your cluster nodes.

### Monitoring the network stack events

The following steps are not exactly required, but they help you to understand what is going on. I suggest you create a set of 3 root shells (the commands have to be executed as root) on node1 (one node is enough). You can do this as you like, but I also would suggest you try the [tmux](https://gist.github.com/MohamedAlaa/2961058) terminal multiplexer, so that you can see all events at the same time. Execute in each shell the following:

Shell 1:

    ip monitor link


Shell 2:

    ip monitor route


Shell 3:

    echo 1 | sudo tee -a /proc/sys/net/ipv4/neigh/eth0/app_solicit
    ip monitor neigh
