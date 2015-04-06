#!/bin/bash

#SBATCH -J poisson_variant
#SBATCH -n 1
#SBATCH -p serial_requeue
#SBATCH --mem-per-cpu 2000
#SBATCH -t 0-05:00
#SBATCH -o Out/varout_%a.txt
#SBATCH -e Out/varerr_%a.txt

matlab -nojvm -nodisplay -nosplash -r "poisson_variant(\${SLURM_ARRAY_TASK_ID});exit"
