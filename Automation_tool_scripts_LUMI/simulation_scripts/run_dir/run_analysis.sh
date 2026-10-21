#!/bin/bash

cd ../..

PROT="Unst_prot"
BASE_DIR=${PWD}
SCRIPTS=${BASE_DIR}/simulation_scripts/MD_scripts
analysis_script=${SCRIPTS}/analysis.sh

echo "Input simulation time in ns:"
read time_input

for i in $BASE_DIR/$PROT/
do
  	cd $i
	jobs=$(( $(find "$i" -mindepth 2 -maxdepth 2 -type d | wc -l) - 1 ))

	cp ${analysis_script} ${SCRIPTS}/batch_analysis.sh
	JOB_SCRIPT=${SCRIPTS}/batch_analysis.sh
	sed -i "s/sim_time=sim_time/sim_time=${time_input}/" "${JOB_SCRIPT}"
	sed -i "s/num_jobs/${jobs}/" "${JOB_SCRIPT}"
	sed -i "s/project/${project}/" "${JOB_SCRIPT}"

	sbatch ${JOB_SCRIPT}
done
