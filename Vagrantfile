# -*- mode: ruby -*-
# vi: set ft=ruby :

# You can login to the master via:
# ssh-add ~/.vagrant.d/insecure_private_key
# ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@192.168.56.101
# ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 2222 vagrant@localhost

Vagrant.require_version ">= 1.6.0"

boxes = [
    {
        :name => "node1",
        :eth1 => "192.168.56.101",
        # :mem => "1024",
        # :cpu => "1"
        :mem => "2048",
        :cpu => "2"
    },
    {
        :name => "node2",
        :eth1 => "192.168.56.102",
        # :mem => "1024",
        # :cpu => "1"
        :mem => "2048",
        :cpu => "2"
    },
]

Vagrant.configure(2) do |config|

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
  config.ssh.insert_key = false
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"


  boxes.each do |opts|
      config.vm.define opts[:name] do |config|
        config.vm.hostname = opts[:name]

        config.vm.box = "bento/ubuntu-16.04"
        config.vm.box_version = "201710.25.0"
        config.vm.box_check_update = false

        config.vm.provider "virtualbox" do |virtualbox|
          virtualbox.gui = false
          virtualbox.customize ["modifyvm", :id, "--memory", opts[:mem]]
          virtualbox.customize ["modifyvm", :id, "--cpus", opts[:cpu]]


          virtualbox.customize ["modifyvm", :id, "--apic", "on"] # turn on I/O APIC
          virtualbox.customize ["modifyvm", :id, "--ioapic", "on"] # turn on I/O APIC
          virtualbox.customize ["modifyvm", :id, "--x2apic", "on"] # turn on I/O APIC
          virtualbox.customize ["modifyvm", :id, "--biosapic", "x2apic"] # turn on I/O APIC
          virtualbox.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"] # set guest OS type
          virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"] # enables DNS resolution from guest using host's DNS
          virtualbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"] # enables DNS requests to be proxied via the host
          virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"] # turn on promiscuous mode on nic 2
          virtualbox.customize ["modifyvm", :id, "--nictype1", "virtio"]
          virtualbox.customize ["modifyvm", :id, "--nictype2", "virtio"]
          virtualbox.customize ["modifyvm", :id, "--pae", "on"] # enables PAE
          virtualbox.customize ["modifyvm", :id, "--longmode", "on"] # enables long mode (64 bit mode in GUEST OS)
          virtualbox.customize ["modifyvm", :id, "--hpet", "on"] # enables a High Precision Event Timer (HPET)
          virtualbox.customize ["modifyvm", :id, "--hwvirtex", "on"] # turn on host hardware virtualization extensions (VT-x|AMD-V)
          virtualbox.customize ["modifyvm", :id, "--nestedpaging", "on"] # if --hwvirtex is on, this enables nested paging
          virtualbox.customize ["modifyvm", :id, "--largepages", "on"] # if --hwvirtex & --nestedpaging are on
          virtualbox.customize ["modifyvm", :id, "--vtxvpid", "on"] # if --hwvirtex on
          virtualbox.customize ["modifyvm", :id, "--vtxux", "on"] # if --vtux on (Intel VT-x only) enables unrestricted guest mode
          virtualbox.customize ["modifyvm", :id, "--boot1", "disk"] # tells vm to boot from disk only
          virtualbox.customize ["modifyvm", :id, "--rtcuseutc", "on"] # lets the real-time clock (RTC) operate in UTC time
          virtualbox.customize ["modifyvm", :id, "--audio", "none"] # turn audio off
          virtualbox.customize ["modifyvm", :id, "--clipboard", "disabled"] # disable clipboard
          virtualbox.customize ["modifyvm", :id, "--usbehci", "off"] # disable usb hot-plug drivers
          virtualbox.customize ["modifyvm", :id, "--vrde", "off"]
          virtualbox.customize [ "setextradata", :id, "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled", 0 ] # turns the timesync on
          virtualbox.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-interval", 10000 ] # sync time every 10 seconds
          virtualbox.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-min-adjust", 100 ] # adjustments if drift > 100 ms
          virtualbox.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-on-restore", 1 ] # sync time on restore
          virtualbox.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-start", 1 ] # sync time on start
          virtualbox.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ] # at 1 second drift, the time will be set and not "smoothly" adjusted
          virtualbox.customize ['modifyvm', :id, '--cableconnected1', 'on'] # fix for https://github.com/mitchellh/vagrant/issues/7648
          virtualbox.customize ['modifyvm', :id, '--cableconnected2', 'on'] # fix for https://github.com/mitchellh/vagrant/issues/7648
          virtualbox.customize ['storagectl', :id, '--name', 'SATA Controller', '--hostiocache', 'on'] # use host I/O cache

        end

        config.vm.network :private_network, ip: opts[:eth1]
        #config.vm.network "private_network", ip: "#{base_segment}.100", adapter_ip: "#{base_segment}.1", netmask: "255.255.255.0", auto_config: false
      end
  end
end
