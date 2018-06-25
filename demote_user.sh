#!/usr/bin/env bash
USERNAME=$1


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# if argument username not empty
if [[ ! "$USERNAME" ]]; then
  echo "No username given!"
  exit 1
else
#  if username is not member of group admin
  echo "First we check if a user '${USERNAME}' exists on the system"
  USER_EXISTS=$(dscl . list /users | grep -F ${USERNAME})
  if [[ ! "$USER_EXISTS" ]]; then
    echo "user '${USERNAME}' does not exist"
    exit 1
  fi
  echo "Checking for admin group membership"
  IS_MEMBER=$(dscl . -read /groups/admin GroupMembership | grep -F ${USERNAME})
  if [[ "$IS_MEMBER" ]]; then
    echo "${USERNAME} is a member of the admin group. Deleting group membership."
    dscl . -delete /groups/admin GroupMembership ${USERNAME}
  else
    echo "${USERNAME} is not a member of the admin group. Skipping."
  fi
fi
exit 0
