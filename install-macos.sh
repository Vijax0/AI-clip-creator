#!/bin/bash

echo "Installing application..."
INSTALL_DIR="$(dirname "$0")/miniconda"

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Downloading Miniconda..."
    curl -o "miniconda_installer.sh" "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-$(uname -m).sh"

    echo "Installing Miniconda..."
    bash "miniconda_installer.sh" -b -p "$INSTALL_DIR" -u
    rm "miniconda_installer.sh"
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
    exit 1
fi

echo "Installing PyTorch..."
pip install torch==2.4.0 --index-url https://download.pytorch.org/whl/cpu

echo "Installing additional requirements..."
pip install -r requirements.txt

echo "Installation complete!"