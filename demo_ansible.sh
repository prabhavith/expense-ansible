- name: Ansible PING play
  hosts: all
  tasks:
   - name: Ping task
     ansible.builtin.ping: