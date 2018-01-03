#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo
  echo "This script must be run as root!"
  echo "Exiting..."
  echo
  sleep 2
  exit 10
fi


start_tftpd() {
  chmod +r /private/tftpboot/*
  launchctl load -F /System/Library/LaunchDaemons/tftp.plist
  launchctl start com.apple.tftpd
  echo
  netstat -an | grep '*.69'
  echo
  exit 0
}


stop_tftpd() {
  launchctl stop com.apple.tftpd
  launchctl unload -F /System/Library/LaunchDaemons/tftp.plist
  echo
  netstat -an | grep '*.69'
  echo
  exit 0
}


no_flags() {
  echo
  echo "Please use one of the following flags:"
  echo
  echo "--start"
  echo "--stop"
  echo
  echo
  echo "NOTE: Running --start adds READ permissions to all files in /private/tftpboot/,"
  echo "which is needed in order for TFTP clients to download the files as necessary."
  echo
  echo "Place all files you want to serve into /private/tftpboot/ FIRST, then run with --start."
  echo "Otherwise, either run 'sudo chmod +r /private/tftpboot/*' OR run --stop, then --start."
  echo
  sleep 2
  exit 20
}


if [[ $# -gt 0 ]]; then
  case "$1" in
    --start)
      echo
      echo "Starting tftp server..."
      echo
      sleep 2
      start_tftpd
      break
      ;;
    --stop)
      echo
      echo "Stopping tftp server..."
      echo
      sleep 2
      stop_tftpd
      break
      ;;
    *)
      no_flags
      break
      ;;
  esac
fi


no_flags
