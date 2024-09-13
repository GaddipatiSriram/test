    - name: Loop through each user for A1 API user 
      ansible.builtin.include_tasks: rotate_user_password.yaml
      when: item == '{{ customer_name }}-a1-api'
      ansible.builitin.set_fact:
        target_safe: '{{ a1_api_safe }}'
      loop: "{{ users }}"

    - name: Loop through rest of the Users
      ansible.builtin.include_tasks: rotate_user_password.yaml
      when: item != '{{ customer_name }}-a1-api'
      ansible.builitin.set_fact:
        target_safe: '{{ app_safe }}'
      loop: "{{ users }}"
