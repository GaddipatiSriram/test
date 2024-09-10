    - name: Import tasks for each Palo Alto device
      ansible.builtin.include_tasks: roles/palo/vpce/associate_vpce.yaml
      loop: "{{ palo_alto_devices }}"
      loop_control:
        loop_var: item
      no_log: true 
