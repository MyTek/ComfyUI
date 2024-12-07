#!/bin/bash

# Set the download location (default: ./models if not set)
DOWNLOAD_DIR=${1:-"./"}

# Create necessary directories
mkdir -p "$DOWNLOAD_DIR/models/custom_nodes"

# Install custom nodes
echo "Installing custom nodes..."
cd "$DOWNLOAD_DIR/models/custom_nodes" || exit

# Get ComfyUI-Manager
if [ -d "ComfyUI-Manager" ]; then
  echo "Updating ComfyUI-Manager..."
  cd ComfyUI-Manager || exit
  git pull origin main  # Pull the latest changes
else
  echo "Cloning ComfyUI-Manager..."
  git clone --depth 1 https://github.com/ltdrdata/ComfyUI-Manager.git
fi

echo "Done"