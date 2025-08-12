#!/bin/sh
# This is a comment!

# Add Docker's official GPG key:
echo "Atualizando os pacotes do sistema..."
sudo apt-get update
sudo apt-get install ca-certificates curl

echo "Adicionando chave"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "Adicionando repositório"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Atualizando novamente os pacotes do sistema..."
sudo apt-get update

echo "Install the Docker packages"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker version"
sudo docker version

echo "Alterando as permissões do Docker para os comandos docker"
# sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

docker version
echo "Docker instalado com sucesso!"
# End of install-docker.sh