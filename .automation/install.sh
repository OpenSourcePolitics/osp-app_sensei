#!/usr/bin/env bash

main() {
	updateSystem
	installAnsible	
	$(ansible --version)
	cronJob
}

updateSystem() {
	echo "[System] - Updating packages..."
	$(sudo apt update)
}

installAnsible() {
	# Steps extracted from https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
	echo "[Ansible] - Installing software-properties-common"
	$(sudo apt install software-properties-common)
	echo "[Ansible] - Adding Ansible PPA"
	$(sudo apt-add-repository --yes --update ppa:ansible/ansible)
	$(sudo apt install ansible)
}

cronJob() {
	# Run every day of the week at 9am. Furthermore, store the logs in ./ansible_log.log

	echo "[CRONJOB] - Add Cron Job every day of the week at 9am."
	echo "[CRONJOB] - Store logs in ./ansible_log.log"
	$(0 9 * * 1-5 echo "run Ansible" > ./ansible_log.log)
}

main
