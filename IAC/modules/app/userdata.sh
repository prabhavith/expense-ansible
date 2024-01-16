#!/bin/bash
touch /home/centos/userdata.log
dnf install ansible -y | tee -a /home/centos/userdata.log
pip3 install boto3 botocore | tee -a /home/centos/userdata.log
ansible-pull -i localhost, -U https://github.com/prabhavith/expense-ansible.git expense.yml -e tier=${component} | tee -a /home/centos/userdata.log