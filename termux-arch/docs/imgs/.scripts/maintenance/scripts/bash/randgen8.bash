#!/usr/bin/env bash
# copyright 2017-2020, all rights reserved by SDRausty; see LICENSE
# generate eight digit random numbers to create uniq strings
##############################################################################
set -eu
declare ONESA
declare STIME
_GENRAND_() {	# if readable then run either _RANDUUID_ or _RANDDATE_
	[[ -r /proc/sys/kernel/random/uuid ]]&&_RANDUUID_||_RANDDATE_
 	printf "\\e[1;7;38;5;0m%s\\e[0m" "$STIME"
 	while true
 	do
 		"$0"
 	done
}
_RANDDATE_() {	# function _RANDDATE_
	_RANDNDATE_() {	# nested function _RANDNDATE_
		ON="$(date +%N)"
		ON="${ON: -2}"
		sleep 0."$(shuf -i 0-9999 -n 1)" 
		ONE="$(date +%N)"
		ONE="${ONE: -2}"
		sleep 0."$(shuf -i 0-9999 -n 1)" 
		ONES="$(date +%N)"
		ONES="${ONES: -2}"
		sleep 0."$(shuf -i 0-9999 -n 1)" 
		ONESA="$(date +%N)"
		ONESA="${ONESA: -2}"
		ONESA="$ON$ONE$ONES$ONESA"
 		STIME="$ONESA"
	}
	_RANDSHUF_() {	# nested function _RANDSHUF_
		ONESA="$(shuf -i 0-99999999 -n 1)" 
		[[ "${#ONESA}" -lt 8 ]]&&TONESA="$ONESA"&&_RANDSHUF_&&ONESA="$ONESA$TONESA"
 		STIME="${ONESA::8}"
	}
	# some busybox date commands lack the nanosecond option
	[[ "$(date +%N 2>/dev/null)" ]]&&_RANDNDATE_||_RANDSHUF_
}
_RANDUUID_() {	# function _RANDUUID_
	STIME="$(cat /proc/sys/kernel/random/uuid)"
	STIME="${STIME//-}"
	STIME="${STIME//[[:alpha:]]}"
	STIME="${STIME::8}"
}
_GENRAND_
# randgen8.bash EOF
