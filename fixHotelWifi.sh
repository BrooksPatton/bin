#!/bin/bash

# This script is for fixing the hotel wifi with Ubuntu systems
GOOGLE_DNS="8.8.8.8"
PING=/bin/ping
GREP=/bin/grep
RESOLV_FILE=/etc/resolv.conf
SUDO=/usr/bin/sudo
SED=/bin/sed
ERR_SED=1
BACKUP_RESOLV_FILE=/tmp/resolve.conf
CP=/bin/cp
RM=/bin/rm

# Functions
function checkErr() {
  if [ "$?" -ne 0 ]
  then
    exit "$1"
  fi
}

function pingGoogleDNS() {
  "$PING" -q -c 3 "$GOOGLE_DNS" > /dev/null 2> /dev/null 
}

function isGoogleDnsInResolv() {
  "$GREP" "$GOOGLE_DNS" "$RESOLV_FILE" > /dev/null 2> /dev/null
}

function backupResolv() {
  "$CP" -p "$RESOLV_FILE" "$BACKUP_RESOLV_FILE"
  checkErr "$ERR_MV"
}

function addGoogleToResolv() {
  "$SUDO" "$SED" -i "/nameserver/ s/ / $GOOGLE_DNS /" "$RESOLV_FILE"
  checkErr "$ERR_SED"
}

function rmBackupResolv() {
  "$RM" "$BACKUP_RESOLV_FILE"
  checkErr "$ERR_RM"
}

# Main
if pingGoogleDNS
then
  
  if isGoogleDnsInResolv
  then
    echo "everything is working properly"
    exit 0
  else
    backupResolv
    addGoogleToResolv
    rmBackupResolv
    echo "internet fixed"
    exit 0
  fi
else
  echo "not connected to internet, log in through hotel gateway first"
  exit 0
fi 
