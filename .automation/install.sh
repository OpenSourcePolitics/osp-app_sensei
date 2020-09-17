#!/usr/bin/env sh

CRON_DELAY="0 9 * * 1-5"
CRON_COMMAND="echo 'run Ansible'"
CRON_LOG_FILE_PATH="./ansible_log.log"

main() {
	updateSystem
	checkIfPipExistsOrInstall
	installAnsibleIfNotExists
  checkIfAnsibleExists
  cronJob

	exit 0
}

# Update system
updateSystem() {
	echo "[System] - Updating packages..."
	sudo apt-get update
}

# Check if pip3 is already installed, or install it
checkIfPipExistsOrInstall() {
	if ! type "pip3" > /dev/null; then
		echo "[pip3] - Does not exist"
		echo "[pip3] - Installing"
		sudo apt-get install python3-pip -y
	else
		echo "[pip3] - Already existing"
	fi
}

# Install Ansible using pip3 if not exists
installAnsibleIfNotExists() {
	if ! type "ansible" > /dev/null; then
		echo "[Ansible] - Does not exist"
    echo "[Ansible] - Installing using pip3"
	  pip3 install ansible
	fi
}

# Exit with code status 1 if ansible is not installed
checkIfAnsibleExists() {
	if ! type "ansible" > /dev/null; then
		echo "[Ansible] - Does not exist"
		echo "[Ansible] - Installation failed"
		exit 1
	fi
}

# Create new cron job
cronJob() {
  crontab -l | grep "$CRON_COMMAND"

  if [ $? -ne "1" ]; then
    echo "[CRONJOB] - Add Cron Job: $CRON_DELAY $CRON_COMMAND > $CRON_LOG_FILE_PATH"
    echo "$CRON_DELAY $CRON_COMMAND > $CRON_LOG_FILE_PATH" | crontab
    crontab -l
  else
    echo "[CRONJOB] - Cron Job is already existing"
  fi
}

main
