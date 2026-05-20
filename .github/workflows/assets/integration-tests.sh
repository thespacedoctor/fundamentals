#!/bin/bash

set -e

ACCEPT_DEFAULTS=false
for arg in "$@"; do
    case $arg in
        -y|--yes) ACCEPT_DEFAULTS=true ;;
    esac
done

echo "## Running Empty Integration Script"

# ASK USER TO CHOOSE TO CONTINUE OR NOT
if $ACCEPT_DEFAULTS; then REPLY=Y; else read -p "Do you want to continue? ([Y]/n) " -r; fi
REPLY=${REPLY:-Y}
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborting."
    exit 1
fi
sleep 1
