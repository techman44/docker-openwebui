#!/usr/bin/env bash
#
# Quick script to deploy the Docker Compose environment.

set -e

# 1. Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker not found. Installing Docker..."
    # Update package info
    sudo apt-get update -y
    # Install packages to allow apt to use https
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release -y

    # Add Docker’s GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the stable repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    echo "Docker has been installed."
fi

# 2. Check if Docker Compose (Plugin) is installed
if ! docker compose version &> /dev/null
then
    echo "Docker Compose plugin not found. Installing..."
    # Install Docker Compose plugin from Docker's repo (for Ubuntu/Debian)
    sudo apt-get update -y
    sudo apt-get install docker-compose-plugin -y
    echo "Docker Compose plugin has been installed."
fi

# 3. Create the docker-compose.yml file
echo "Creating docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: '3.9'  # Compose v2 will ignore this, but it's okay to leave.

services:
  #################################################################
  # NGINX PROXY MANAGER
  #################################################################
  nginx-proxy-manager:
    image: jc21/nginx-proxy-manager:latest
    container_name: npm
    restart: unless-stopped
    ports:
      - "80:80"      # HTTP
      - "81:81"      # Admin UI
      - "443:443"    # HTTPS
    volumes:
      - ./npm/data:/data
      - ./npm/letsencrypt:/etc/letsencrypt
    networks:
      - app-net

  #################################################################
  # OPENWEBUI (OLLAMA) – LLM Container
  #################################################################
  openwebui_ollama:
    image: ghcr.io/open-webui/open-webui:ollama
    container_name: open_webui_ollama
    restart: unless-stopped

    # GPU reservations
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

    environment:
      NVIDIA_VISIBLE_DEVICES: "all"
      NVIDIA_DRIVER_CAPABILITIES: "all"
      CLI_ARGS: "--api --listen 0.0.0.0 --port 8080"
    volumes:
      - ./openwebui/models:/root/.ollama
      - ./openwebui/data:/app/backend/data

    # Map 3000 externally to 8080 internally, so you can open http://HOST:3000
    ports:
      - "3000:8080"
    networks:
      - app-net

networks:
  app-net:
    driver: bridge
EOF

echo "docker-compose.yml has been created."

# 4. Deploy the containers
echo "Starting Docker containers..."
docker compose up -d

echo "Deployment completed. Run 'docker compose ps' to see container status."
