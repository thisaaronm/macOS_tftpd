#!/bin/bash


# ================================ FUNCTIONS ================================= #
root_check() {
  if [[ $EUID -ne 0 ]]; then
    echo
    echo "This script must be run as root!"
    echo "Exiting..."
    echo
    sleep 2
    exit 10
  fi
}


start_tftpd() {
  chmod a+rw /private/tftpboot/*
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
  chmod 644 /private/tftpboot/*
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
  echo "--start sets permissions to at least 666 for all files in /private/tftpboot/,"
  echo "which is required for TFTP clients to download/upload files to/from /private/tftpboot/."
  echo 
  echo "--stop sets permissions to 644 for all files in /private/tftpboot/."
  echo
  echo "Place all files you want to serve/receive into /private/tftpboot/ FIRST, then run --start."
  echo "Otherwise, either run 'sudo chmod a+rw /private/tftpboot/*' OR run --stop, then --start."
  echo
  echo "NOTE: If receiving files, you must run 'sudo touch /private/tftpboot/[filename]',."
  echo "before starting the TFTP server. If you created the empty file after starting the"
  echo "TFTP server, run --stop, then --start."
  echo
  sleep 2
  exit 20
}


# ================================= RUN IT! ================================== #
root_check

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
