#!/bin/bash

set -e


# Detect OS
OS="$(uname -s)"

# Install Ansible
if ! command -v ansible &> /dev/null; then
  echo "Ansible not found. Installing..."
  if [[ "$OS" == "Linux" ]]; then
    if [ -f /etc/debian_version ]; then
      apt update
#      apt install -y software-properties-common
#      apt-add-repository --yes --update ppa:ansible/ansible

      apt install -y ansible
    elif [ -f /etc/redhat-release ]; then

      yum install -y epel-release
      yum install -y ansible
    else

      echo "Unsupported Linux distribution."
      exit 1
    fi
  elif [[ "$OS" == "Darwin" ]]; then
    if ! command -v brew &> /dev/null; then
      echo "Homebrew not found. Installing..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install ansible
  else
    echo "Unsupported OS."
    exit 1
  fi

else
  echo "Ansible is already installed."
fi


# Run the Ansible playbook
ansible-playbook setup.yml --ask-vault-pass
