#!/bin/bash -l
# maxdet.sh

#SBATCH --mail-user=ybili@ucdavis.edu
#SBATCH --mail-type=ALL

#SBATCH --output=maxdet-%j.out
#SBATCH --error=maxdet-%j.err

# Request a GPU (1x 10gb)
#SBATCH --gpus=1g.20gb:1

# Request a certain amount of time (1 hour)
#SBATCH --time=04:00:00

# Request cpus (i want 4 for this job)
#SBATCH --cpus-per-gpu=4

# Request RAM (below = 8gb x4 cpu =32gb for the job)
#SBATCH --mem-per-cpu=8gb

conda activate pytorch
python fc_loop.py --exp_name=dim11_run_23 --dump_path=/home/yuebi/Project/dim11_run --num_initial_empty_objects=600 --final_database_size=15 --target_db_size=15 --nb_local_searches=800 --max_epochs=20 --type=transformer --max-output-length=131 --sample-only=30000 --max-steps=1000 --n_tokens=15 --n-layer=8 --n-embd=128 --n-embd2=128