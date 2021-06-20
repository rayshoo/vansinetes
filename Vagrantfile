# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'
require 'fileutils'

class Machine
  def initialize(image, name, role, cpus, memory, network_ip, host_port, gui)
    @image = image
    @name = name
    @role = role
    @cpus = cpus
    @memory = memory
    @network_ip = network_ip
    @host_port = host_port
    @gui = gui
  end

  def get_image
    return @image
  end
  def get_name
    return @name
  end
  def get_role
    return @role
  end
  def get_cpus
    return @cpus
  end
  def get_memory
    return @memory
  end
  def get_network_ip
    return @network_ip
  end
  def get_host_port
    return @host_port
  end
  def get_gui
    return @gui
  end
end

class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def yellow;         "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def white;          "\033[37m#{self}\033[0m" end
end

def str_to_bool(obj)
  value = obj.to_s.downcase
  return (value == "yes" or value == "true")
end

def read_file(file)
  aFile = File.new(file, 'r')
  fSize = aFile.stat.size
  content = aFile.sysread(fSize)
  return content
end

def write_file(text, name)
  aFile = File.new(name, "w")
  aFile.syswrite(text)
end

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.env.enable

  master = ENV['MASTER'].to_i
  worker = ENV['WORKER'].to_i
  master_initial = ENV['MASTER_INITIAL']
  worker_initial = ENV['WORKER_INITIAL']
  default_network_ip = ENV['DEFAULT_NETWORK_IP'].split(".")
  default_network = "#{default_network_ip[0]}.#{default_network_ip[1]}.#{default_network_ip[2]}"
  default_ip = default_network_ip.last.to_i
  server_network_type = ENV["SERVER_NETWORK_TYPE"] != "" ? ENV["SERVER_NETWORK_TYPE"] || ENV["DEFAULT_NETWORK_TYPE"] :  ENV["DEFAULT_NETWORK_TYPE"]
  server_interface = server_network_type == "public" ? ENV["SERVER_NETWORK_INTERFACE"] != "" ? ENV["SERVER_NETWORK_INTERFACE"] || ENV["DEFAULT_NETWORK_INTERFACE"] : ENV["DEFAULT_NETWORK_INTERFACE"] || nil : nil
  server_netmask = ENV['SERVER_NETWORK_NETMASK'] != "" ? ENV['SERVER_NETWORK_NETMASK'] || ENV["DEFAULT_NETWORK_NETMASK"] : ENV["DEFAULT_NETWORK_NETMASK"]
  root_pass_script = nil

  machines = Array.new
  
  for i in 1..master + worker
    default_cpus = (i > worker) ? ENV['DEFAULT_MASTER_CPUS'].to_i : ENV['DEFAULT_WORKER_CPUS'].to_i
    default_memory = (i > worker) ? ENV['DEFAULT_MASTER_MEMORY'] : ENV['DEFAULT_WORKER_MEMORY']
    server_name = (i > worker) ? "#{master_initial}#{master - (i - worker) + 1}" : "#{worker_initial}#{worker - i + 1}"
    server_role = (i > worker) ? "master" : "worker"
    i = master + worker - i + 1
    server_image = ENV["#{i}_SERVER_IMAGE"] != "" ? ENV["#{i}_SERVER_IMAGE"] || ENV["DEFAULT_IMAGE"] : ENV["DEFAULT_IMAGE"]
    server_cpus = ENV["#{i}_SERVER_CPUS"] != "" ? ENV["#{i}_SERVER_CPUS"] || default_cpus : default_cpus
    server_memory = ENV["#{i}_SERVER_MEMORY"] != "" ? (ENV["#{i}_SERVER_MEMORY"] || default_memory).to_i : default_memory.to_i
    server_network_ip = ENV["#{i}_SERVER_NETWORK_IP"] != "" ? ENV["#{i}_SERVER_NETWORK_IP"] || "#{default_network}.#{default_ip + i - 1}" : "#{default_network}.#{default_ip + i - 1}"
    server_host_port = ENV["#{i}_SERVER_HOST_PORT"]  != "" ? ENV["#{i}_SERVER_HOST_PORT"] || ENV["DEFAULT_HOST_PORT"].to_i + i - 1 :  ENV["DEFAULT_HOST_PORT"].to_i + i - 1
    server_gui = ENV["#{i}_SERVER_GUI"] != "" ? str_to_bool(ENV["#{i}_SERVER_GUI"] || ENV["DEFAULT_GUI"]) : str_to_bool(ENV["DEFAULT_GUI"])
    server_machine = Machine.new(server_image, server_name, server_role, server_cpus, server_memory, server_network_ip, server_host_port, server_gui)
    machines.push(server_machine)
    
    if str_to_bool(ENV["DEBUG"] || ENV['debug'] || false)
      puts "-----------------------------------".magenta
      puts "server#{i}_name: #{server_machine.get_name}"
      puts "server#{i}_role: #{server_machine.get_role}"
      puts "server#{i}_image: #{server_machine.get_image}"
      puts "server#{i}_cpus: #{server_machine.get_cpus}"
      puts "server#{i}_memory: #{server_machine.get_memory}"
      puts "server#{i}_network_ip: #{server_machine.get_network_ip}"
      puts "server#{i}_host_port: #{server_machine.get_host_port}"
      puts "server#{i}_gui: #{server_machine.get_gui}"
    end
  end
  if str_to_bool(ENV["DEBUG"] || ENV['debug'] || false)
    puts "-----------------------------------".magenta
  end

  if str_to_bool(ENV['FILE_CREATE'] || false)
    template = ERB.new File.read('templates/hosts.erb')
    write_file(template.result(binding), 'ansible/hosts.ini')

    Dir.foreach("ansible/host_vars") do | entry |
      if (entry != "." && entry != ".." && entry != ".gitkeep")
        FileUtils.remove_dir("ansible/host_vars/#{entry}")
      end
    end
    content = read_file("templates/host_vars.rb")
    for node in machines
      write_file(content, "ansible/host_vars/#{node.get_name}.yaml")
    end
  end

  if ENV['ROOT_PASS'] || ENV['root_pass'] || ENV['ROOT_PASSWORD'] || ENV['root_password']
    check = true
    while check
      print "\nEnter the root password to set : ".blue
      root_pass = STDIN.noecho(&:gets).chomp
      print "\nConfirm Password : ".blue
      root_pass_check = STDIN.noecho(&:gets).chomp
      if root_pass == root_pass_check
        check = false
      else
        print"\npassword mismatch\n".red
      end
    end
    print "\npassword match\n".green
    template = ERB.new File.read('templates/root_pass.erb')
    root_pass_script = template.result(binding)
  end

  provision = str_to_bool(ENV['PROVISION'] || ENV['provision']  || false)

  (0..machines.length - 1).each do |i|
    machine = machines.at(i)
    
    config.vm.define machine.get_name do |j|
      j.vm.box = machine.get_image
      j.vm.host_name = machine.get_name

      if server_network_type == "public"
        j.vm.network "public_network", ip: machine.get_network_ip, netmask: server_netmask, :bridge => server_interface
      else
        j.vm.network "private_network", ip: machine.get_network_ip
      end
      j.vm.network "forwarded_port", guest: 22, host: machine.get_host_port, auto_correct: false, id: "ssh"
      j.vm.provider :virtualbox do |vb, override|
        vb.gui = machine.get_gui
        vb.name = machine.get_name
        vb.memory = machine.get_memory
        vb.cpus = machine.get_cpus
      end
      j.vm.boot_timeout = 600

      if provision
        if ENV['ROOT_PASS'] || ENV['root_pass'] || ENV['ROOT_PASSWORD'] || ENV['root_password']
          j.vm.provision "shell", inline: root_pass_script
        end
        if i < machines.length - 1
          j.vm.provision "shell", path: "scripts/bash_ssh_conf.sh"
        else
          j.vm.provision "file", source: "ansible", destination: "ansible"
          j.vm.provision "shell", path: "scripts/bootstrap.sh"
          if str_to_bool(ENV["DEBUG"] || ENV['debug'] || false)
            j.vm.provision "shell", keep_color: true, inline: "cd ansible && ANSIBLE_FORCE_COLOR=true ansible-playbook site.yaml -v", privileged: false
          else
            j.vm.provision "shell", keep_color: true, inline: "cd ansible && ANSIBLE_FORCE_COLOR=true ansible-playbook site.yaml", privileged: false
          end
        end
      end
    end
  end
end



