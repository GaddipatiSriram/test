- name: Set initial device configuration as a fact
  ansible.builtin.set_fact:
    initial_device_config: "{{ initial_template_response.json.data }}"

- name: Filter device config by snmp_user
  ansible.builtin.set_fact:
    snmp_user_config: "{{ initial_device_config | selectattr('SNMP_USERNAME', 'equalto', snmp_username) | list }}"
