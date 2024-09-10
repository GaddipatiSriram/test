security_rules:
  - rule_name: "{{ customer_name }}-sdwan-east-allow"
    source_ip:
      - "{{ customer_name }}-sdwan-east"
    destination_ip:
      - "{{ customer_name }}-sdwan-east"
      - cisco_urls
    application:
      - any
    service:
      - application-default
    action: "allow"
  
  - rule_name: "{{ customer_name }}-sdwan-east-dtls"
    source_ip:
      - "{{ vz_data_center_ip }}"
      - US
    destination_ip:
      - "{{ customer_name }}-sdwan-east"
    application:
      - cisco-viptela-ipsec-esp
      - dtls
    service:
      - application-default
    action: "allow"
  
  - rule_name: "{{ customer_name }}-sdwan-east-netconf"
    source_ip:
      - "{{ customer_name }}-sdwan-east"
    destination_ip:
      - "{{ customer_name }}-sdwan-east"
    application:
      - any
    service:
      - netconf
      - TLS
    action: "allow"
  
  - rule_name: "{{ customer_name }}-sdwan-east-tls"
    source_ip:
      - "{{ vz_data_center_ip }}"
      - US
    destination_ip:
      - "{{ customer_name }}-sdwan-east"
    application:
      - any
    service:
      - TLS
    action: "allow"
  
  - rule_name: "{{ customer_name }}-sdwan-east-deny"
    source_ip:
      - any
    destination_ip:
      - any
    application:
      - any
    service:
      - any
    action: "deny"
