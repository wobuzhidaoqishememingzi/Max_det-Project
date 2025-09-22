#!/bin/bash -l
# max_det.sh

# Request a GPU (1x 10gb)
#SBATCH --gpus=1g.20gb:2

# Request a certain amount of time (1 minutes)
#SBATCH --time=04:00:00

# Request cpus
#SBATCH --cpus-per-gpu=2

# Request RAM
#SBATCH --mem-per-cpu=8gb

echo -n "I have been allocated the following CUDA device(s): "
echo  $CUDA_VISIBLE_DEVICES

echo -n "I am running on the node: "
hostname

echo "Here is the output of nvidia-smi"
nvidia-smi