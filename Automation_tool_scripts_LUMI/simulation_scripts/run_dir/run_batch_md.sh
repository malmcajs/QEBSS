#!/bin/bash

cd ../..

BASE_DIR=$PWD
SIM_DIR=$BASE_DIR
PROT="Unst_prot"

echo "Input simulation time in ns:"
read time_input


your_projects=$(lumi-allocations | grep -o "project_.*" | awk '{print $1}')
echo "Select the number of the project you want to use:"

num=1
list=()

for i in $your_projects; do
        list+=($i)
        echo "("$num")" ${i} 
        ((num++))
done

read choice
project=${list[choice-1]}



SCRIPTS=$BASE_DIR/simulation_scripts/MD_scripts
md_script=${SCRIPTS}/md.sh
cp ${md_script} ${SCRIPTS}/batch_md.sh
JOB_SCRIPT=${SCRIPTS}/batch_md.sh

sed -i "s/sim_time=sim_time/sim_time=${time_input}/" "${JOB_SCRIPT}"
sed -i "s/project/${project}/" "${JOB_SCRIPT}"
sed -i "s/sim_time=sim_time/sim_time=${time_input}/" "${JOB_SCRIPT}"

for i in  $SIM_DIR/$PROT/*/*/; do
    if ! ls *pdb 1> /dev/null 2>&1; then
        continue
    fi


    id="${i}"

    # Check job status
    job_status=$(squeue -u "$USER" -n "$id" -h -o "%T")
    # If job is not running and no completed output file exists
    if [[ "$job_status" != "RUNNING" && "$job_status" != "PENDING" ]]; then
        sbatch --job-name="$id" "${JOB_SCRIPT}"
    fi
done
