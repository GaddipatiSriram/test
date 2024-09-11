- name: Panorama Config Playbook
  hosts: all
  gather_facts: no
  connection: local
  vars_files:
    - sdwan_vars.yaml

  tasks:
    - name: Credential retrieval
      delegate_to: localhost
      no_log: true  # Set to true to avoid logging sensitive information
      block:
        - name: Panorama Credential retrieval
          cyberark.pas.cyberark_credential:
            api_base_url: "{{ ca_api_base_url }}"
            app_id: "{{ ca_app_id }}"
            query: Safe={{ panorama_safe }};Object={{ inventory_hostname }}-admin
            validate_certs: false
            client_cert: "{{ cert_dir_ee }}/ca.cert"
            client_key: "{{ cert_dir_ee }}/ca.pem"
          register: panorama_ca_response
          until: panorama_ca_response.failed == false
          retries: 6
          delay: 10
          no_log: true

    - name: Set provider
      ansible.builtin.set_fact:
        provider:
          ip_address: '{{ inventory_hostname }}'
          username: '{{ username | default(omit) }}'
          password: '{{ panorama_ca_response.result.Content | default(omit) }}'

    - name: Refresh facts to clear the cache
      ansible.builtin.setup:
        gather_subset: '!all'

    - name: Create Panorama Objects west
      ansible.builtin.include_role:
        name: pano/create_objects
      vars:
        device_group_name: '{{ device_group_west }}'  

    - name: Create Panorama Objects east
      ansible.builtin.include_role:
        name: pano/create_objects
      vars:
        device_group_name: '{{ device_group_east }}'  
                  
    - name: Create Panorama  Object Group west
      ansible.builtin.include_role:
        name: pano/create_object_group
      vars:
        device_group_name: '{{ device_group_west }}'  

    - name: Create Panorama  Object Group east
      ansible.builtin.include_role:
        name: pano/create_object_group
      vars:
        device_group_name: '{{ device_group_east }}'  

    - name: Create Zones
      ansible.builtin.include_role:
        name: pano/create_zones

    - name: Create Sub Interfaces
      ansible.builtin.include_role:
        name: pano/create_sub_interfaces

    - name: Create panorama security rules west
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
        device_group: '{{ device_group_west }}'
        location: 'before'
        existing_rule: 'ALL-ALLOW'
        antivirus: '{{ sdwan_antivirus_profile }}'
        vulnerability: '{{ sdwan_vulnerability_profile }}'
        spyware: '{{ sdwan_spyware_profile }}'
        url_filtering: '{{ sdwan_url_filtering_profile }}'
        log_end: yes
        log_setting: '{{ log_forwarding_profile }}'

    - name: Create panorama security rules east
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
        device_group: '{{ device_group_east }}'
        location: 'before'
        existing_rule: 'ALL-ALLOW'
        antivirus: '{{ sdwan_antivirus_profile }}'
        vulnerability: '{{ sdwan_vulnerability_profile }}'
        spyware: '{{ sdwan_spyware_profile }}'
        url_filtering: '{{ sdwan_url_filtering_profile }}'
        log_end: yes
        log_setting: '{{ log_forwarding_profile }}'

    - name: ethernet1/3 as static in VR sdwan-vr
      paloaltonetworks.panos.panos_interface:
        provider: '{{ provider }}'
        if_name: "ethernet1/3"
        mode: "layer3"
        enable_dhcp: true
        vr_name: 'sdwan-vr'
        management_profile: 'palo-sdwan-gwlb-health'
        adjust_tcp_mss: true
        zone_name: 'sdwan'
        template: '{{ template_name }}'

    - name: commit candidate configs on panorama
      paloaltonetworks.panos.panos_commit_panorama:
        provider: '{{ provider }}'

    - name: push template configs and force values
      paloaltonetworks.panos.panos_commit_push:
        provider: '{{ provider }}'
        style: 'template'
        name: '{{ template_name }}'
        sync: true
        force_template_values: false
       
    - name: Push to multiple devices
      paloaltonetworks.panos.panos_commit_push:
        provider: '{{ provider }}'
        include_template: true
        style: 'device group'
        name: '{{ item.name }}'
        devices: '{{ item.serial_number }}'
        sync: true
      loop: "{{ palo_alto_devices }}"

    - name: Drop admin session
      paloaltonetworks.panos.panos_op:
        provider: '{{ provider }}'
        cmd: 'delete admin-sessions'

- name: Palo Alto SDWAN Config Playbook
  hosts: all
  gather_facts: no
  connection: local
  vars_files:
    - sdwan_vars.yaml

  tasks:
    - name: Import tasks for each Palo Alto device in the specified region
      ansible.builtin.include_tasks: roles/palo/vpce/associate_vpce.yaml
      loop: "{{ palo_alto_devices | selectattr('region', 'equalto', 'east') | list }}"
      loop_control:
        loop_var: item
      no_log: true
