#!/bin/bash

###############################################################################
# Docker Installation Script
# This script automates the installation of Docker and related components on
# an Ubuntu system. It handles repository setup, package installation, and
# user configuration.
###############################################################################

# SECTION 1: SETUP PREREQUISITES AND DOCKER GPG KEY
# -------------------------------------------------
# Update package lists to ensure we get the latest versions
sudo apt-get update

# Install required base packages for secure communications
sudo apt-get install -y ca-certificates curl

# Create secure directory for storing GPG keys with proper permissions
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key for package verification
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Set appropriate read permissions for the GPG key
sudo chmod a+r /etc/apt/keyrings/docker.asc

# SECTION 2: CONFIGURE DOCKER REPOSITORY
# -------------------------------------
# Add Docker's official package repository to our system sources:
# - Uses the system's architecture (amd64, arm64, etc)
# - References our downloaded GPG key for verification
# - Targets the appropriate Ubuntu release codename
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Refresh package lists to include the newly added Docker repository
sudo apt-get update

# SECTION 3: INSTALL DOCKER COMPONENTS
# -----------------------------------
# Install the Docker ecosystem packages:
# - docker-ce: Docker Community Edition (core engine)
# - docker-ce-cli: Command Line Interface
# - containerd.io: Container runtime
# - docker-buildx-plugin: Extended build capabilities
# - docker-compose-plugin: Container orchestration tool
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# SECTION 4: CONFIGURE USER PERMISSIONS
# ------------------------------------
# Add current user to the docker group to allow management without sudo
sudo usermod -aG docker $USER

# SECTION 5: COMPLETION NOTIFICATION
# ---------------------------------
# Display completion message
echo "Docker installation and setup completed successfully"
echo "Note: You may need to log out and back in for group changes to take effect"