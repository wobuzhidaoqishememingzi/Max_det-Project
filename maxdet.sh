#!/bin/bash -l
# maxdet.sh

#SBATCH --mail-user=ybili@ucdavis.edu
#SBATCH --mail-type=ALL

#SBATCH --output=maxdet-%j.out
#SBATCH --error=maxdet-%j.err

# Request a GPU (1x 20gb)
#SBATCH --gpus=1g.20gb:1

# Request a certain amount of time (4 hour)
#SBATCH --time=04:00:00

# Request cpus
#SBATCH --cpus-per-gpu=2

# Request RAM (below = 8gb x4 cpu =32gb for the job)
#SBATCH --mem-per-cpu=8gb


# This will set the SLURM_NTASKS environment variable to "1"
#SBATCH --ntasks=1

source ~/.bashrc
conda activate pytorch
python fc_loop.py --exp_name=dim12_run_30 --dump_path=/home/yuebi/Project/dim12_run --num_initial_empty_objects=800 --final_database_size=100 --target_db_size=100 --nb_local_searches=800 --max_epochs=20 --type=transformer --max-output-length=155 --sample-only=50000 --max-steps=1500 --n_tokens=15 --n-layer=8 --n-embd=128 --n-embd2=128 --exp_id=1111