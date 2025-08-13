#!/bin/bash

echo " ██ ███    ███ ██    ██  ██████  ███████ ██    ██ ██   ██ ██  
██  ████  ████  ██  ██  ██    ██ ██      ██    ██ ██   ██  ██ 
██  ██ ████ ██   ████   ██    ██ █████   ██    ██ ███████  ██ 
██  ██  ██  ██    ██    ██    ██ ██       ██  ██  ██   ██  ██ 
 ██ ██      ██    ██     ██████  ██        ████   ██   ██ ██ "

echo "Make your own Free VPS Hosting, Dont Allow Mining"

# Kiểm tra biến môi trường AGREE_NO_MINING để bỏ nhập tay
if [ "$AGREE_NO_MINING" != "yes" ]; then
  echo "❌ Installation aborted. Set AGREE_NO_MINING=yes to continue."
  exit 1
fi
echo "✅ Proceeding with installation..."

cd ~

echo "Installing python3-pip..."
sudo apt update
sudo apt install -y python3-pip
echo "Installed successfully"

echo "Writing Dockerfile..."
cat <<EOF > Dockerfile
FROM ubuntu:22.04
RUN apt update
RUN apt install -y tmate
EOF
echo "Dockerfile created successfully"

echo "Building Docker image..."
sudo docker build -t ubuntu-22.04-with-tmate .
echo "Docker image built successfully"

echo "Downloading main.py from the GitHub repository..."
wget -O main.py https://raw.githubusercontent.com/katy-the-kat/discord-vps-creator/refs/heads/main/v3ds
echo "Downloaded main.py successfully"

echo "Installing Python packages: discord and docker..."
pip3 install --upgrade pip
pip3 install discord docker

# Token Discord từ biến môi trường hoặc nhập tay nếu trên VPS
if [ -z "$DISCORD_TOKEN" ]; then
  echo "🔑 Please enter your Discord bot token:"
  read -r DISCORD_TOKEN
fi

# Cập nhật token trong main.py nếu chưa có
if grep -q "TOKEN = ''" main.py; then
    sed -i "s/TOKEN = ''/TOKEN = '$DISCORD_TOKEN'/" main.py
    echo "✅ Updated main.py with your Discord token."
else
    echo "⚠️ TOKEN variable not found in main.py. Skipping token update."
fi

echo "Starting the Discord bot..."
echo "To start the bot in the future, run: python3 main.py"
python3 main.py
