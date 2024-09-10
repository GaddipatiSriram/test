    - name: Create panorama security rules
      ansible.builtin.include_role:
        name: pano/create_security_policies
      vars:
        rule_name: '{{ sdwan_allow_rule_name }}'
        source_zone: ['{{ zone_name }}']
        destination_zone: ['{{ zone_name }}']
        source_ip: '{{ sdwan_allow_source_ip }}'
        destination_ip: '{{ sdwan_allow_destination_ip }}'
        application: '{{ sdwan_allow_application }}'
        service: '{{ sdwan_allow_service }}'
        action: 'allow'
        tag_name: [] 
        device_group: '{{ device_group_name }}'
        location: 'before'
        existing_rule: 'ALL-ALLOW'
        antivirus: '{{ sdwan_antivirus_profile}}'
        vulnerability: '{{ sdwan_vulnerability_profile}}'
        spyware: '{{ sdwan_spyware_profile}}'
        url_filtering: '{{ sdwan_url_filtering_profile}}'
        log_end: yes
        log_setting: '{{ log_forwarding_profile }}'

    - name: Create {{ sdwan_dtls_rule_name }} rules
      ansible.builtin.include_role:
        name: pano/create_security_policies
      vars:
        rule_name: '{{ sdwan_dtls_rule_name }}'
        source_zone: ['{{ zone_name }}']
        destination_zone: ['{{ zone_name }}']
        source_ip: '{{ sdwan_dtls_source_ip }}'
        destination_ip: '{{ sdwan_dtls_destination_ip }}'
        application: '{{ sdwan_dtls_application }}'
        service: '{{ sdwan_dtls_service }}'
        action: 'allow'
        tag_name: [] 
        device_group: '{{ device_group_name }}'
        location: 'before'
        existing_rule: 'ALL-ALLOW'
        antivirus: '{{ sdwan_antivirus_profile}}'
        vulnerability: '{{ sdwan_vulnerability_profile}}'
        spyware: '{{ sdwan_spyware_profile}}'
        url_filtering: '{{ sdwan_url_filtering_profile}}'
        log_end: yes
        log_setting: '{{ log_forwarding_profile }}'

    - name: Create {{ sdwan_netconf_rule_name }} rules
      ansible.builtin.include_role:
        name: pano/create_security_policies
      vars:
        rule_name: '{{ sdwan_netconf_rule_name }}'
        source_zone: ['{{ zone_name }}']
        destination_zone: ['{{ zone_name }}']
        source_ip: '{{ sdwan_netconf_source_ip }}'
        destination_ip: '{{ sdwan_netconf_destination_ip }}'
        application: '{{ sdwan_netconf_application }}'
        service: '{{ sdwan_netconf_service}}'
        action: 'allow'
        tag_name: [] 
        device_group: '{{ device_group_name }}'
        location: 'before'
        existing_rule: 'ALL-ALLOW'
        antivirus: '{{ sdwan_antivirus_profile}}'
        vulnerability: '{{ sdwan_vulnerability_profile}}'
        spyware: '{{ sdwan_spyware_profile}}'
        url_filtering: '{{ sdwan_url_filtering_profile}}'
        log_end: yes
        log_setting: '{{ log_forwarding_profile }}'

    - name: Create {{ sdwan_tls_rule_name }} rules
      ansible.builtin.include_role:
        name: pano/create_security_policies
      vars:
        rule_name: '{{ sdwan_tls_rule_name }}'
        source_zone: ['{{ zone_name }}']
        destination_zone: ['{{ zone_name }}']
        source_ip: '{{ sdwan_tls_source_ip }}'
        destination_ip: '{{ sdwan_tls_destination_ip }}'
        application: '{{ sdwan_tls_application }}'
        service: '{{ sdwan_tls_service}}'
        action: 'allow'
        tag_name: [] 
        device_group: '{{ device_group_name }}'
        location: 'before'
        existing_rule: 'ALL-ALLOW'
        antivirus: '{{ sdwan_antivirus_profile}}'
        vulnerability: '{{ sdwan_vulnerability_profile}}'
        spyware: '{{ sdwan_spyware_profile}}'
        url_filtering: '{{ sdwan_url_filtering_profile}}'
        log_end: yes
        log_setting: '{{ log_forwarding_profile }}'

    - name: Create {{ sdwan_deny_rule_name }} rules
      ansible.builtin.include_role:
        name: pano/create_security_policies
      vars:
        rule_name: '{{ sdwan_deny_rule_name }}'
        source_zone: ['{{ zone_name }}']
        destination_zone: ['{{ zone_name }}']
        source_ip: '{{ sdwan_deny_source_ip }}'
        destination_ip: '{{ sdwan_deny_destination_ip }}'
        application: '{{ sdwan_deny_application }}'
        service: '{{ sdwan_deny_service}}'
        action: 'deny'
        tag_name: [] 
        device_group: '{{ device_group_name }}'
        location: 'before'
        existing_rule: 'ALL-ALLOW'
        antivirus: '{{ sdwan_antivirus_profile}}'
        vulnerability: '{{ sdwan_vulnerability_profile}}'
        spyware: '{{ sdwan_spyware_profile}}'
        url_filtering: '{{ sdwan_url_filtering_profile}}'
        log_end: yes
        log_setting: '{{ log_forwarding_profile }}'
