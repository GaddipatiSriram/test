- name: Import tasks for each Palo Alto device in the specified region
  ansible.builtin.include_tasks: roles/palo/vpce/associate_vpce.yaml
  loop: "{{ palo_alto_devices | selectattr('region', 'equalto', 'west') | list }}"
  loop_control:
    loop_var: item
  no_log: true
