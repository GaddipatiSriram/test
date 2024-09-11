## Change per environment
# Palo Variables
palo_alto_devices:
  - ip_address: 172.16.4.167
    username: admin
    name: Palo-dev-west-1a
    serial_number: '007955000395706'
    region: west
  - ip_address: 172.16.5.252
    username: admin
    name: Palo-dev-west-1b
    serial_number: '007955000396093'
    region: west
  - ip_address: 172.24.20.231
    username: admin
    name: Palo-dev-east-1a
    serial_number: '007955000403579'
    region: east
  - ip_address: 172.24.21.27
    username: admin
    name: Palo-dev-east-1b
    serial_number: '007955000452196'
    region: east

# Pano Variables    
username: admin
vz_data_center_ip: 204.177.181.142
device_group_east: Palo Dev Gov East
device_group_west: Palo Dev Gov West
template_name: "Subinterface-Routing-Zone-TPL"
vr_name: sdwan-vr
interface_name: "ethernet1/3"

# logging
log_forwarding_profile: Palo-dev-log-forwarding

# Do not Change
### Resources created
zone_name: "{{ customer_name }}-sdwan"
object_group_name: "{{ customer_name }}-sdwan-east"
sub_interface_name: "{{ interface_name }}.{{ sub_interface_tag }}"

# Security rules
security_rules:
  - rule_name: "{{ customer_name }}-sdwan-allow"
    source_ip:
      - '{{ customer_name }}-sdwan-east'
      - '{{ customer_name }}-sdwan-west'
    destination_ip:
      - "{{ customer_name }}-sdwan-east"
      - "{{ customer_name }}-sdwan-west"
      - cisco_urls
    application:
      - any
    service:
      - application-default
    action: "allow"
  
  - rule_name: "{{ customer_name }}-sdwan-dtls"
    source_ip:
      - "{{ vz_data_center_ip }}"
      - US
    destination_ip:
      - "{{ customer_name }}-sdwan-east"
      - "{{ customer_name }}-sdwan-west"
    application:
      - cisco-viptela-ipsec-esp
      - dtls
    service:
      - application-default
    action: "allow"
  
  - rule_name: "{{ customer_name }}-sdwan-netconf"
    source_ip:
      - "{{ customer_name }}-sdwan-east"
      - "{{ customer_name }}-sdwan-west"
    destination_ip:
      - "{{ customer_name }}-sdwan-east"
      - "{{ customer_name }}-sdwan-west"
    application:
      - any
    service:
      - netconf
      - TLS
    action: "allow"
  
  - rule_name: "{{ customer_name }}-sdwan-tls"
    source_ip:
      - "{{ vz_data_center_ip }}"
      - US
    destination_ip:
      - "{{ customer_name }}-sdwan-east"
      - "{{ customer_name }}-sdwan-west"
    application:
      - any
    service:
      - TLS
    action: "allow"

# security profiles
sdwan_antivirus_profile: 'default'
sdwan_vulnerability_profile: 'strict'
sdwan_spyware_profile: 'strict'
sdwan_url_filtering_profile: 'default'

