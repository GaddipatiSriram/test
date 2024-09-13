- name: Loop through each user for A1 API user 
  ansible.builtin.include_tasks: rotate_user_password.yaml
  when: item == '{{ customer_name }}-a1-api'
  loop: "{{ users }}"
  loop_control:
    loop_var: item
  vars:
    target_safe: '{{ a1_api_safe }}'  # Set the fact for the current iteration

- name: Loop through rest of the Users
  ansible.builtin.include_tasks: rotate_user_password.yaml
  when: item != '{{ customer_name }}-a1-api'
  loop: "{{ users }}"
  loop_control:
    loop_var: item
  vars:
    target_safe: '{{ app_safe }}'  # Set the fact for the current iteration
