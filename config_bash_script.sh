#!/bin/bash

agent install
-----------------------------------------------------
# Create a new user
sudo adduser --disabled-password --gecos "" svc_devops_deploy

# Add the user to the sudo group
sudo usermod -aG sudo svc_devops_deploy

# Configure sudoers file to allow passwordless sudo for the user
echo 'svc_devops_deploy ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/svc_devops_deploy

# Set permissions for the sudoers file
sudo chmod 0440 /etc/sudoers.d/svc_devops_deploy

# Switch to svc_devops_deploy user
sudo su - svc_devops_deploy

# Configure DNS settings
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Download and extract VSTS agent package
cd /
cd media
sudo mkdir azagent
cd azagent
sudo wget https://vstsagentpackage.azureedge.net/agent/3.220.2/vsts-agent-linux-x64-3.220.2.tar.gz
sudo tar zxvf vsts-agent-linux-x64-3.220.2.tar.gz

# Configure and setup agent as a Service
./config.sh --unattended --url https://dev.azure.com/mortgageconnect/ --auth pat --token PAT --pool DevOps-Terraform-POC --agent pbq-poc --work _w
./svc.sh install
./svc.sh start



install pre-requisities
----------------------------------------------------------
# Update package lists
sudo apt update

# Install unzip
sudo apt-get install -y unzip

# Download and install Microsoft package repository configuration
sudo wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

# Update package lists again
sudo apt update

# Install .NET SDK 6.0
sudo apt-get install -y dotnet-sdk-6.0

# Install Nginx
sudo apt install -y nginx

# Allow Nginx through the firewall
sudo ufw allow 'Nginx Full'

# Start Nginx service
sudo service nginx start


application install - separate pipeline
---------------------------------------------------------

# Update DNS settings
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Create directories
sudo mkdir -p /media/devops/azagent/pbq
sudo mkdir -p /var/www/pbq

# Unzip pbq.zip to pbq directory
unzip "$(Pipeline.Workspace)/pbq.zip" -d /media/devops/azagent/pbq

# Copy files to respective locations
sudo cp -r /media/devops/pbq/* /var/www/pbq/
sudo cp "$(Pipeline.Workspace)/pbq/site-configuration.txt" /etc/nginx/sites-available/pbq
sudo cp "$(Pipeline.Workspace)/pbq/service-configuration.txt" /etc/systemd/system/pbq.service

# Restart Nginx
sudo systemctl restart nginx

# Start pbq service
sudo service pbq start
