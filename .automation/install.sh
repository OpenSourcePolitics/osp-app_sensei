#!/usr/bin/env sh

# TODO: Let user overrides params
readonly CRON_DELAY="0 9 * * 1-5"
readonly CRON_COMMAND="echo 'run Ansible'"
readonly CRON_LOG_FILE_PATH="./ansible_log.log"

main() {
	updateSystem
	checkIfPipExists
	installAnsible	
    checkIfAnsibleIsInstalled
    cronJob

	exit 0
}

updateSystem() {
	echo "[System] - Updating packages..."
	sudo apt-get update
}

installAnsible() {
    # TODO : Check if already installed
	# Steps extracted from https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
	echo "[Ansible] - Installing using pip3"
	pip3 install --user ansible
}

cronJob() {
    # TODO: CHECK if already added in cron
	# Run every day of the week at 9am. Furthermore, store the logs in ./ansible_log.log

	echo "[CRONJOB] - Add Cron Job: $CRON_DELAY $CRON_COMMAND > $CRON_LOG_FILE_PATH"
	echo "$CRON_DELAY $CRON_COMMAND > $CRON_LOG_FILE_PATH" | crontab
	crontab -l
}

checkIfPipExists() {
	if ! type "pip3" > /dev/null; then
		echo "[pip3] - Does not exist"
		echo "[pip3] - Installing"
		sudo apt-get install python3-pip -y
	else
		echo "[pip3] - Already existing"
	fi
}

checkIfAnsibleIsInstalled() {
	if ! type "ansible" > /dev/null; then
		echo "[Ansible] - Does not exist"
		echo "[Ansible] - Installation failed"
		exit 1
	fi
}

main
