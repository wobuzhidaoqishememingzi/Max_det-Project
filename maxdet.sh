#!/bin/bash -l
# maxdet.sh

#SBATCH --mail-user=ybili@ucdavis.edu
#SBATCH --mail-type=ALL

#SBATCH --output=maxdet-%j_%a.out # %j is jobID, %a is the array index
#SBATCH --error=maxdet-%j_%a.err

# Request a GPU (1x 20gb)
#SBATCH --gpus=1g.20gb:1

# Request a certain amount of time (4 hour)
#SBATCH --time=01:00:00

# Request cpus
#SBATCH --cpus-per-gpu=2

# Request RAM (below = 8gb x4 cpu =32gb for the job)
#SBATCH --mem-per-cpu=8gb

#SBATCH --array=1-2%1
#SBATCH --dependency=singleton

# This will set the SLURM_NTASKS environment variable to "1"
#SBATCH --ntasks=1

source ~/.bashrc
conda activate pytorch
python fc_loop.py --exp_name=dim11_run_27 --dump_path=/home/yuebi/Project/dim11_run --num_initial_empty_objects=300 --final_database_size=20 --target_db_size=20 --nb_local_searches=500 --max_epochs=20 --type=transformer --max-output-length=131 --sample-only=5000 --max-steps=300 --n_tokens=15 --n-layer=8 --n-embd=128 --n-embd2=128