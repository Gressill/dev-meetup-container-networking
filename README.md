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

The first node will get IP address `192.168.56.101` and the second node will get IP address `192.168.56.101`. You will only have to add once the ssh key and afterwards you can login without password. I suggest you login into both nodes before you continue. Sometimes the booting process takes a bit longer and the next steps will fail if the ssh login does not work.
