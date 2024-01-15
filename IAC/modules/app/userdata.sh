#!/bin/bash
dnf install ansible -y
pip3 install boto3 botocore
ansilbe-pull -i localhost, -U https://github.com/prabhavith/expense-ansible.git expense.yml -e tier=${component}