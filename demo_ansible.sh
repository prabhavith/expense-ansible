- name: Ansible PING play
  hosts: 172.31.41.217
  tasks:
   - name: Ping task
     ansible.builtin.ping: