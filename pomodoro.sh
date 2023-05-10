#!/bin/bash

#Set the sound file location here
SOUND_FILE_PATH="/path/to/file.mp3"

RED='\033[0;31m'
WHITE='\033[1;37'
BLUE='\033[1;34m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

echo -en "\e]2;shPomo\007"
echo -en "${WHITE}${BOLD}Length of the pomodoro: ${RESET}"
read countdown_minutes
echo -en "${WHITE}${BOLD}Length of the break: ${RESET}"
read break_minutes
original_break_minutes=$break_minutes
echo -en "${WHITE}${BOLD}Length of the longer break: ${RESET}"
read longer_break_minutes
echo -en "${WHITE}${BOLD}Countdowns before the longer break: ${RESET}"
read countdowns_before_longer_break
clear
countdowns_completed=0
total_time=0

while true; do
	echo -e "${RED}${BOLD}Counting down ${RESET}${WHITE}${BOLD}$countdown_minutes ${RESET}${RED}${BOLD}minutes...${RESET}"

	countdown_end_time=$(date -d "+$countdown_minutes minutes" +%s)

	while [ $(date +%s) -lt "$countdown_end_time" ]; do
		countdown_remaining_time=$(date -u -d @$((countdown_end_time - $(date +%s))) +%M:%S)
		printf "\r${RED}${BOLD}Count:${RESET} ${WHITE}${BOLD}%s${RESET}" "$countdown_remaining_time"
		sleep 1
	done

	printf "\n"

	countdowns_completed=$((countdowns_completed + 1))

	total_time=$((total_time + countdown_minutes))

	notify-send "Countdown complete!" "Countdown duration: $countdown_minutes minutes"

	mpg123 -q $SOUND_FILE_PATH &

	if [ "$countdowns_before_longer_break" -gt 0 ] && [ $((countdowns_completed > 0 && countdowns_completed % countdowns_before_longer_break == 0)) -eq 1 ]; then
		if [ "$longer_break_minutes" -eq 0 ]; then
			break_minutes=$original_break_minutes
		else
			break_minutes=$longer_break_minutes
		fi
	else
		break_minutes=$original_break_minutes
	fi
	echo -en "${WHITE}${BOLD}Do you want to start a $break_minutes minute break? (Y/n) ${RESET}"
	read -n 1 start_break
	clear
	if [ "$start_break" = "" ] || [ "$start_break" = "y" ] || [ "$start_break" = "Y" ]; then
		echo -e "${WHITE}${BOLD}Total time elapsed: $total_time minutes${RESET}"
		echo -e "${GREEN}${BOLD}Countdowns completed: ${RESET}${WHITE}${BOLD}$countdowns_completed${RESET}"
		echo -e "${RED}${BOLD}Starting ${RESET}${WHITE}${BOLD}${break_minutes} ${RESET}${RED}${BOLD}minute break...${RESET}"

		break_end_time=$(date -d "+$break_minutes minutes" +%s)

		while [ $(date +%s) -lt "$break_end_time" ]; do
			break_remaining_time=$(date -u -d @$((break_end_time - $(date +%s))) +%M:%S)
			printf "\r${RED}${BOLD}Break:${RESET} ${WHITE}${BOLD}%s${RESET}" "$break_remaining_time"
			sleep 1
		done

		printf "\n"

		notify-send "Break complete!" "Break duration: $break_minutes minutes"

		mpg123 -q $SOUND_FILE_PATH &

		echo -en "${WHITE}${BOLD}Do you want to start a $countdown_minutes minute pomodoro? (Y/n) ${RESET}"
		read -n 1 restart
		clear
		if [ "$restart" = "" ] || [ "$restart" = "y" ] || [ "$restart" = "Y" ]; then
			echo -e "${WHITE}${BOLD}Total time elapsed: $total_time minutes${RESET}"
		else
			break
		fi

		echo -e "${GREEN}${BOLD}Countdowns completed: ${RESET}${WHITE}${BOLD}$countdowns_completed${RESET}"
	else
		break
	fi
done
echo -e "${RED}${BOLD}Exiting countdown and break timer.${RESET}"
echo -e "${GREEN}${BOLD}Countdowns completed: ${RESET}${WHITE}${BOLD}$countdowns_completed${RESET}"
echo -e "${WHITE}${BOLD}Total time elapsed: $total_time minutes${RESET}"
