# Docker Compose deployment of Openwebui and NPM . 

Can be used in Widnwos with WSL2


---

## Step 1: 
Prerequisites

- **Windows 10 or 11** with [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) enabled.
- **Ubuntu 24.04** (WSL2) installed from the Microsoft Store.
- **Docker Desktop** [installed](https://www.docker.com/products/docker-desktop) on Windows, configured with WSL2 integration.

---

## Step 2: 
Enable and Configure WSL2 (Ubuntu 24.04)

1. **Install WSL** (if not already) from PowerShell:
   ```powershell
   wsl --install


By default, this may install Ubuntu 22.04 or another version.

Install Ubuntu 24.04:

Open the Microsoft Store, search for Ubuntu 24.04, and click Get or Install.
If it’s not listed, you may need to wait until Canonical publishes it or stick with the default Ubuntu version.
Check that you’re on WSL2:

wsl --list --verbose
If Version is 2 for Ubuntu-24.04, you’re good.
If it’s 1, convert it:

wsl --set-version Ubuntu-24.04 2
(Replace Ubuntu-24.04 with whatever name appears in the list.)
Launch Ubuntu from your Start menu and create a username and password when prompted.

## Step 3:
Install Docker Desktop (with WSL2 Integration)
Download Docker Desktop for Windows and run the installer. (https://www.docker.com/products/docker-desktop/)
Enable WSL2 during setup if prompted.
Open Docker Desktop → Settings → Resources → WSL Integration:
Turn on integration (toggle or checkbox) for Ubuntu-24.04.
Restart Docker Desktop to apply changes.


## Step 4: 
Clone or Download This Repository
In Ubuntu (WSL2) terminal, change to a desired directory:

cd ~
Clone the repository:

git clone https://github.com/techman44/docker-openwebui.git
cd docker-openwebui

If you prefer, download the ZIP from GitHub and extract it into your Ubuntu filesystem under /home/<username>.

## Step 5:
Run Docker Compose
From the same folder as the docker-compose.yml file:

docker compose --compatibility up -d
--compatibility ensures older Compose fields (like deploy) work correctly.
-d runs containers in detached mode (in the background).



## Step 6:
Stopping the Containers
To stop all running containers in this Compose project:

docker compose down
This stops and removes them, letting you redeploy fresh later.

## Step 8: 
Troubleshooting
Docker Not Found in Ubuntu (WSL2):
Make sure Docker Desktop is running on Windows and WSL integration is enabled for Ubuntu.
Check WSL Version:
Use wsl --list --verbose in PowerShell to confirm your Ubuntu version is set to WSL2.
GPU / Advanced Features:
If leveraging GPU passthrough, install appropriate drivers on Windows and consider the NVIDIA Container Toolkit for Ubuntu.
