
#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io openjdk-17-jdk

systemctl enable docker
systemctl start docker

# Add users to docker group
usermod -aG docker ubuntu || true
useradd -m jenkins || true
usermod -aG docker jenkins

# Swap
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

# Sysctl for SonarQube
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf
sysctl -p

# Run SonarQube
docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  sonarqube:lts-community
