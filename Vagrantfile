IMAGE = "ubuntu/bionic64"

# Kubernetes Master Node Settings
MASTER_NAME = "master"
MASTER_SIZE = 1
MASTER_CPU = 2 
MASTER_MEM = 2048

# Kubernetes Worker Node Settings
NODE_NAME = "node"
NODE_SIZE = 1
NODE_CPU = 2
NODE_MEM = 2048

# Kubernetes Cluster IP Network
IP_BASE = "192.168.50."

# Ansible Settings
ANSIBLE_PLAYBOOK = "setup.yaml"

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
    end
    
    (1..MASTER_SIZE).each do |i|
        config.vm.define "master" do |master|
            master.vm.box = IMAGE
            master.vm.network "private_network", ip: "#{IP_BASE}10"
            master.vm.hostname = MASTER_NAME
            config.vm.provider "virtualbox" do |v|
                v.memory = MASTER_MEM
                v.cpus = MASTER_CPU
            end
            master.vm.provision "ansible" do |ansible|
                ansible.playbook = ANSIBLE_PLAYBOOK
                ansible.groups = {
                    "masters" => ["#{MASTER_NAME}"],
                }
                ansible.extra_vars = {
                    node_ip: "#{IP_BASE}10",
                }
            end
        end
    end

    (1..NODE_SIZE).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE
            node.vm.network "private_network", ip: "#{IP_BASE}#{i + 10}"
            node.vm.hostname = "#{NODE_NAME}-#{i}"
            config.vm.provider "virtualbox" do |v|
                v.memory = NODE_MEM
                v.cpus = NODE_CPU
            end
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = ANSIBLE_PLAYBOOK
                ansible.groups = {
                    "nodes" => ["#{NODE_NAME}-#{i}"],
                }
                ansible.extra_vars = {
                    node_ip: "#{IP_BASE}#{i + 10}",
                }
            end
        end
    end
end