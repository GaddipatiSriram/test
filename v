# Security Rules
# Default Security rule
sdwan_allow_rule_name: "{{ customer_name }}-sdwan-east-allow"
sdwan_allow_source_ip: 
  - "{{ customer_name }}-sdwan-east"
sdwan_allow_destination_ip:
  - "{{ customer_name }}-sdwan-east"
  - cisco_urls
sdwan_allow_application:
  - any
sdwan_allow_service:
  - application-default

# Customer specific DTLS rule
sdwan_dtls_rule_name: "{{ customer_name }}-sdwan-east-dtls"
sdwan_dtls_source_ip: 
  - "{{ vz_data_center_ip }}"
  - US
sdwan_dtls_destination_ip: 
  - "{{ customer_name }}-sdwan-east"
sdwan_dtls_application:
  - cisco-viptela-ipsec-esp
  - dtls
sdwan_dtls_service:
  - application-default

# Customer specific NETCONF rule
sdwan_netconf_rule_name: "{{ customer_name }}-sdwan-east-netconf"
sdwan_netconf_source_ip: 
  - "{{ customer_name }}-sdwan-east"
sdwan_netconf_destination_ip: 
  - "{{ customer_name }}-sdwan-east"
sdwan_netconf_application:
  - any
sdwan_netconf_service:
  - netconf
  - TLS

# Customer specific TLS rule
sdwan_tls_rule_name: "{{ customer_name }}-sdwan-east-tls"
sdwan_tls_source_ip: 
  - "{{ vz_data_center_ip }}"
  - US
sdwan_tls_destination_ip: 
  - "{{ customer_name }}-sdwan-east"
sdwan_tls_application:
  - any
sdwan_tls_service:
  - TLS

# Customer specific Deny rule
sdwan_deny_rule_name: "{{ customer_name }}-sdwan-east-deny"
sdwan_deny_source_ip: 
  - any
sdwan_deny_destination_ip: 
  - any
sdwan_deny_application:
  - any
sdwan_deny_service:
  - any

# security profiles
sdwan_antivirus_profile: 'default'
sdwan_vulnerability_profile: 'strict'
sdwan_spyware_profile: 'strict'
sdwan_url_filtering_profile: 'default'

