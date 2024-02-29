  tasks:
    - name: Remove items from a dictionary based on a list of keys
      set_fact:
        # Initialize filtered_dict or combine it with a new item if its key is not in keys_to_remove
        filtered_dict: "{{ filtered_dict | default({}) | combine({item.key: item.value}) }}"
      # Loop over original_dict, converting it to a list of items
      loop: "{{ original_dict | dict2items }}"
      # Condition to include the item only if its key is not in keys_to_remove
      when: item.key not in keys_to_remove

# update_passwords.yml
- name: Update the password for each key in the filtered dictionary with a unique password
  set_fact:
    filtered_dict: "{{ filtered_dict | combine({item.key: (lookup('password', '/dev/null length=15 chars=ascii_letters,digits')) }) }}"
  loop: "{{ filtered_dict | dict2items }}"
