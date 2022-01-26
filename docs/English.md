# Vansinetes
## Main
### [README](../README.md)

## Requirements before use

[Vagrant](https://www.vagrantup.com/downloads) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) must be installed in the user's environment in advance.

## How to Use

<span>1.</span> Configure the [.env](../.env), [templates/cluster.erb](../templates/cluster.erb) files. (The basic settings are already done)
```sh
# .env
MIRROR_CHANGE=yes
# There was a case where an error occurred due to a repo problem in the generic/centos8 image.
# In this case, change this option to yes and refer to the repo files in the files/mirror path and create them.
```
<span>2.</span> Some tools are commented out to speed up provisioning. Uncomment the necessary parts in [ansible/site.yaml](../ansible/site.yaml).

```sh
- name: utils, components install
  hosts: cluster
  roles:
  # - role: utils/k9s
  # - role: utils/stern
  # - role: utils/dashboard
  # - role: utils/builder
  # - role: utils/skopeo
  # - role: utils/compose
```
<span>3.</span> Type the following command into the bash shell in the path where the [Vagrantfile](../Vagrantfile) is located.

```sh
$ vagrant plugin install vagrant-env && \
vagrant up --no-provision && \
vagrant snapshot save up && \
root_pass=vagrant vagrant provision --color && \
vagrant halt && \
vagrant snapshot save kube && \
vagrant up

$ vagrant ssh $(vagrant status | tail -5 | sed -n '1p' | awk '{ print $1}')
password: vagrant
```

## Command

```sh
# Install required plugins
$ vagrant plugin install vagrant-env

# Create a snapshot of the initial installation state in case provisioning fails
$ vagrant up --no-provision
$ vagrant snapshot save up

# It can be initialized with the saved snapshot with the following command
$ vagrant snapshot restore up

# If you specify the root_pass=true option, you can specify the root password at the prompt.
$ root_pass=true vagrant provision --color
# Alternatively, you can directly enter the password excluding 'true' and 'yes' in the terminal.
$ root_pass=<password> vagrant provision --color

# For more detailed information, add the debug option.
$ debug=true root_pass=true vagrant provision --color

# Connect to master node
$ vagrant ssh $(vagrant status | tail -5 | sed -n '1p' | awk '{ print $1}')

# If it is the default setting, you can access it with the following command
$ vagrant ssh m1
$ ssh vagrant@10.254.1.51 # In a Linux environment, a separate host network configuration is required in a virtual box
$ ssh -p 5701 vagrant@localhost

# initial vagrant user password
vagrant
```

## Note

Several aliases are automatically registered.

```
alias ans='ansible'
alias anp='ansible-playbook'
alias vi='vim'
alias d='docker'
alias k='kubectl'
```

A private docker registry is created and can be used with initial admin account.(password: admin)<br/>
User settings can be set in [templates/cluster.erb](../templates/cluster.erb#118).
```
$ curl -Lu 'admin:admin' m1.dev/v2/
{}
$ curl -Lu 'admin:admin' registry.m1.dev/v2/
{}
```

You can use docker and kubectl commands as the vagrant user.
```
$ d ps
$ k get nodes -o wide
```

## Trouble Shooting

<span>1.</span> If provisioning fails, try again with the **vagrant provision** command.

<span>2.</span> When deleting and recreating a virtual machine like **vagrant destroy --force && vagrant up**,<br/>
it appears to have been deleted normally, but it is not actually deleted once at a time. Check it yourself, delete it, and try again.