  - name: Create panorama security rules
    ansible.builtin.include_role:
      name: pano/create_security_policies
    loop: "{{ security_rules }}"
    vars:
      rule_name: "{{ item.rule_name }}"
      source_zone: ['{{ zone_name }}']
      destination_zone: ['{{ zone_name }}']
      source_ip: "{{ item.source_ip }}"
      destination_ip: "{{ item.destination_ip }}"
      application: "{{ item.application }}"
      service: "{{ item.service }}"
      action: "{{ item.action }}"
      tag_name: []
      device_group: '{{ device_group_name }}'
      location: 'before'
      existing_rule: 'ALL-ALLOW'
      antivirus: '{{ sdwan_antivirus_profile }}'
      vulnerability: '{{ sdwan_vulnerability_profile }}'
      spyware: '{{ sdwan_spyware_profile }}'
      url_filtering: '{{ sdwan_url_filtering_profile }}'
      log_end: yes
      log_setting: '{{ log_forwarding_profile }}'
