#!/usr/bin/env sh

main() {
	updateSystem
	checkIfPipExists
	installAnsible	
	installation_status="$(checkIfAnsibleIsInstalled)"
	
	if [[ $installation_status -eq "0" ]]; then
		cronJob
	fi
}

updateSystem() {
	echo "[System] - Updating packages..."
	$(sudo apt update)
}

installAnsible() {
	# Steps extracted from https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
	echo "[Ansible] - Installing using pip3"
	$(pip3 install --user ansible)
}

cronJob() {
	# Run every day of the week at 9am. Furthermore, store the logs in ./ansible_log.log

	echo "[CRONJOB] - Add Cron Job every day of the week at 9am."
	echo "[CRONJOB] - Store logs in ./ansible_log.log"
	#$(0 9 * * 1-5 echo "run Ansible" > ./ansible_log.log)
}

checkIfPipExists() {
	if ! type "pip3" > /dev/null; then
		echo "[pip3] - Does not exist"
		echo "[pip3] - Installing"
		$(sudo apt install python3-pip)
	else
		echo "[pip3] - Already existing"
	fi
}

checkIfAnsibleIsInstalled() {
	if ! type "ansible" > /dev/null; then
		echo "[Ansible] - Does not exist"
		echo "[Ansible] - Installation failed"
		echo "1"
	else
		echo "0"
	fi
}

main
