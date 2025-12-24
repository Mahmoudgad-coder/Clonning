#!/bin/bash
set -e

apt update -y
apt install -y wget curl gnupg

mkdir -p /etc/apt/keyrings

# Java 17 (Temurin)
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public \
 | tee /etc/apt/keyrings/adoptium.asc

echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] \
https://packages.adoptium.net/artifactory/deb \
$(awk -F= '/^VERSION_CODENAME/{print $2}' /etc/os-release) main" \
| tee /etc/apt/sources.list.d/adoptium.list

apt update -y
apt install -y temurin-17-jdk libatomic1

# Jenkins repo
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
 | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" \
| tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y
apt install -y jenkins

# Docker
apt install -y docker.io
systemctl enable docker
systemctl start docker

# Jenkins docker permission
usermod -aG docker jenkins

# Swap
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

# Jenkins service
systemctl enable jenkins
systemctl restart jenkins
