#!/bin/bash

echo "Installing application..."
INSTALL_DIR="$(dirname "$(readlink -f "$0")")/miniconda"

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Downloading Miniconda.."
    wget -O miniconda_installer.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

    echo "Installing Miniconda..."
    bash miniconda_installer.sh -b -p "$INSTALL_DIR" -u
    rm miniconda_installer.sh
fi

echo "Creating conda environment..."
source "$INSTALL_DIR/bin/activate"

if [ ! -d "$INSTALL_DIR/envs/app_env" ]; then
    echo "Creating python environment..."
    conda create -y -n app_env python=3.10 -q
fi

conda activate app_env
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to activate app_env environment"
    echo "Installation aborted to prevent system Python modification"
    read -p "Press enter to continue"
    exit 1
fi

echo "Installing PyTorch..."
if pip install torch==2.4.0+cu118 --index-url https://download.pytorch.org/whl/cu118; then
    echo "PyTorch with CUDA 11.8 installed successfully."
else
    echo "Failed to install PyTorch with CUDA 11.8. Installing CPU-only version..."
    pip install torch==2.4.0+cpu --index-url https://download.pytorch.org/whl/cpu
fi

echo "Installing additional requirements..."
pip install -r requirements.txt

echo "Installation complete!"
read -p "Press enter to continue"