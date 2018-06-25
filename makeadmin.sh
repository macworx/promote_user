#!/usr/bin/env bash
USERNAME=$1


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# if argument username not empty
if [[ ! "$USERNAME" ]]; then
  echo "no username given!"
  exit 1
else
#  if username is not member of group admin
  echo "first we check if a user '${USERNAME}' exists on the system"
  USER_EXISTS=$(dscl . list /users | grep -F ${USERNAME})
  if [[ ! "$USER_EXISTS" ]]; then
    echo "user '${USERNAME}' does not exist"
    exit 1
  fi
  echo "checking for admin group membership"
  IS_MEMBER=$(dscl . -read /groups/admin GroupMembership | grep -F ${USERNAME})
  if [[ ! "$IS_MEMBER" ]]; then
    echo "${USERNAME} is not member of the admin group. appending group membership"
    dscl . -append /groups/admin GroupMembership ${USERNAME}
  else
    echo "${USERNAME} is already a member of the admin group. skipping."
  fi
fi
exit 0
