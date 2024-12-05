#!/bin/bash

echo "admin123" | sudo -S adduser --disabled-password --gecos "" svc_devops_deploy

# Add the user to the sudo group
echo "admin" | sudo -S usermod -aG sudo svc_devops_deploy

echo 'svc_devops_deploy:admin123456' | sudo chpasswd



# # Set ownership and permissions for the sudoers file
# echo "admin123" | sudo -S chmod 0440 /etc/sudoers.d/
# echo "admin123" | sudo -S chown root:root /etc/sudoers.d/

# echo "admin123" | sudo -S chmod 0440 /etc/sudoers.d/svc_devops_deploy
# echo "admin123" | sudo -S chown root:root /etc/sudoers.d/svc_devops_deploy

# # Configure sudoers file to allow passwordless sudo for the new user
# echo "svc_devops_deploy ALL=(ALL) NOPASSWD:ALL" | sudo -S tee /etc/sudoers.d/svc_devops_deploy



