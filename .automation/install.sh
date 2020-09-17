#!/usr/bin/env sh

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
	sudo apt-get update -y
}

installAnsible() {
	# Steps extracted from https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
	echo "[Ansible] - Installing using pip3"
	pip3 install --user ansible
}

cronJob() {
	# Run every day of the week at 9am. Furthermore, store the logs in ./ansible_log.log

	echo "[CRONJOB] - Add Cron Job every day of the week at 9am."
	echo "[CRONJOB] - Store logs in ./ansible_log.log"
	#`$CRON_DELAY $CRON_COMMAND > $CRON_LOG_FILE_PATH`

}

checkIfPipExists() {
	if ! type "pip3" > /dev/null; then
		echo "[pip3] - Does not exist"
		echo "[pip3] - Installing"
		sudo apt-get install python3-pip
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
