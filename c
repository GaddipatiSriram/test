    - name: Push to multiple devices
      paloaltonetworks.panos.panos_commit_push:
        provider: '{{ provider }}'
        include_template: true
        style: 'device group'
        name: '{{ item.name }}'
        devices: '{{ item.serial_number }}'
        sync: true
      loop: "{{ palo_alto_devices }}"
