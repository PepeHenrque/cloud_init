Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "servidor-devops"
  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.network "forwarded_port",
    guest: 80, host: 8080, auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 1
  end

  # Transfere o arquivo user-data para a VM
  config.vm.provision "file", source: "user-data", destination: "/tmp/user-data"

  config.vm.provision "shell", path: "cloud-init_setup.sh" 
end