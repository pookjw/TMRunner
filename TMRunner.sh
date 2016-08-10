#!/bin/sh
# TMRunner (build : 4)
BUILD=4

function showHelpMessage(){
	echo "TMRunner (build : ${BUILD})"
	echo "./TMRunner.sh [option]"
	echo "--applicationpath [path] : Run Time Machine Restore App from macOS Installer."
	echo "example : ./TMRunner.sh --applicationpath /path/to/app"
}

function checkVolumeMounted(){
	if [[ -d "/Volumes/OS X Install ESD" ]]; then
		echo "Please unmount '/Volumes/OS X Install ESD' before doing this."
		MOUNT_ERROR=YES
	fi
	if [[ -d "/Volumes/OS X Base System" ]]; then
		echo "Please unmount '/Volumes/OS X Base System' before doing this."
		MOUNT_ERROR=YES
	fi
	if [[ ${MOUNT_ERROR} == YES ]]; then
		exit 1
	fi
}

if [[ "${1}" == "--applicationpath" ]]; then
	if [[ -z "${2}" ]]; then
		showHelpMessage
		exit 1
	fi
	if [[ ! -d "${2}" ]]; then
		echo "${2}: No such file or directory"
		exit 1
	fi
	checkVolumeMounted
	if [[ "${3}" == "-noverify" || "${4}" == "-noverify" ]]; then
		hdiutil attach "${2}/Contents/SharedSupport/InstallESD.dmg" -noverify
	else
		hdiutil attach "${2}/Contents/SharedSupport/InstallESD.dmg"
	fi
	if [[ ! -f "/Volumes/OS X Install ESD/BaseSystem.dmg" ]]; then
		echo "/Volumes/OS X Install ESD/BaseSystem.dmg: No such file or directory"
		echo "ERROR!"
		exit 1
	fi
	if [[ "${3}" == "-noverify" || "${4}" == "-noverify" ]]; then
		hdiutil attach "/Volumes/OS X Install ESD/BaseSystem.dmg" -noverify
	else
		hdiutil attach "/Volumes/OS X Install ESD/BaseSystem.dmg"
	fi
	if [[ ! -f "/Volumes/OS X Base System/System/Installation/CDIS/Time Machine System Restore.app/Contents/MacOS/Time Machine System Restore" ]]; then
		echo "/Volumes/OS X Base System/System/Installation/CDIS/Time Machine System Restore.app/Contents/MacOS/Time Machine System Restore: No such file or directory"
		echo "ERROR!"
		exit 1
	fi
	if [[ "${3}" == "-showFinder" || "${4}" == "-showFinder" ]]; then
		open "/Volumes/OS X Base System/System/Installation/CDIS"
	fi
	"/Volumes/OS X Base System/System/Installation/CDIS/Time Machine System Restore.app/Contents/MacOS/Time Machine System Restore"
	exit 0
else
	showHelpMessage
	exit 0
fi
