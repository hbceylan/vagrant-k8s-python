# Development Environment on Kubernetes cluster

### **Description**
Developers use different software languages to develop applications. Usually, due to local environment differences, developers observe different outputs from the same codebase. For a smooth development process, this shouldn’t be the case.

This project's aim is preparing Docker containers to standardize the development environments and solve this and similar issues.

To achieve this, I have used `Vagrant` for instance provisioning, `Kubernetes` as the container orchestration and `Ansible` for configuration automation. The project has aimed a demo `Python` application but you can use any language depends on your current development software language such as Golang, Java, etc.

There are 3 core steps:
- VM provisioning by using `Vagrant`
- `Kubernetes` cluster installation by using `Ansible`
- Application build `script` for building a local image and deploy

### **Demo application**
- Application has been written by using `Python3`
- The application needs a `MySQL` database for datastore
- You can build the application by using `build.sh` script. 
- `Vagrant` syncs the repo's root folder to the `/vagrant` path of the VMs. So you don't need to copy the changed files to the VM for the build process.
- The application uses the following environment variables:
  - MYSQL_USERNAME
  - MYSQL_PASSWORD
  - MYSQL_INSTANCE_NAME
  - MYSQL_PORT_3306_TCP_ADDR
  - MYSQL_PORT_3306_TCP_PORT


### **Features**
- You can able to increase or decrease `Kubernetes` cluster size by editing the environment variables inside of the `Vagrantfile`.
- If you need more instances for testing purposes like application availability test on multi-node, just increase the node size inside of the `Vagrantfile`.
- Persistency can be enabled on the Kubernetes cluster by using Persistent Volume (PV) and Persistent Volume Claim (PVC).
- MySQL pod uses PVC for the persistent data store 

### **Requirements**
- `Vagrant 2.2.9` or later: https://www.vagrantup.com/downloads.html
- `Ansible 2.9.12` or later: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-machine

### **Automation Outputs**
- 2 VM instances
- Kubernetes cluster - 1 master, 1 node
- Containerized Python application

### **Project Structure**
```
.
├── LICENSE
├── README.md
├── Vagrantfile
├── app
│   ├── Dockerfile
│   ├── app.py
│   ├── app.yaml
│   ├── mysql.yaml
│   └── requirements.txt
├── build.sh
├── group_vars
│   └── all
├── k8s-configs
│   ├── config
│   └── join-command
├── roles
│   ├── docker
│   │   └── tasks
│   │       ├── install.yaml
│   │       └── main.yml
│   ├── k8s-install
│   │   └── tasks
│   │       ├── install.yaml
│   │       └── main.yml
│   ├── master
│   │   └── tasks
│   │       ├── install.yaml
│   │       └── main.yaml
│   └── node
│       └── tasks
│           ├── install.yaml
│           └── main.yaml
├── setup.yaml
```

### **Example Usage**
- `Clone` the repository and navigate to the repo's `root` folder

- Run `vagrant up` command. This will provision `2 VMs` which are master and node instances. Then the `ansible-playbook` will install the `Kubernetes` cluster as `1 master` and `1 node`.

- Run `build.sh` script to `build` and `deploy` the application to the `Kubernetes` cluster. After the execution, you should see the information like below:

```
#########
 The application is running on the 'busayr/hello-devops-dev:4932133f558e' image.
 ----------------------------------------------------------
 You can access http://192.168.50.11:30300
#########
```

### **License**
Apache License 2.0