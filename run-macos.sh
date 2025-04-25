#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/miniconda/bin/activate" 
conda activate "$SCRIPT_DIR/miniconda/envs/app_env"
python "$SCRIPT_DIR/main.py"
read -p "Press enter to continue"