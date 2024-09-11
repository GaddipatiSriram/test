# Panorama and Palo Alto SD-WAN Configuration Playbook

This Ansible playbook automates the configuration of Panorama and Palo Alto firewalls for SD-WAN deployments across multiple regions (east and west). It retrieves credentials from CyberArk, configures devices, creates security rules, zones, sub-interfaces, and commits the configuration changes.

## Requirements

- Ansible 2.9 or later
- Palo Alto Networks Ansible Galaxy roles
- Access to CyberArk for credential retrieval
- Panorama configured for SD-WAN management

## Playbook Structure

This playbook is divided into two primary sections:

1. **Panorama Configuration**
   - Configures Panorama with objects, object groups, security policies, zones, and sub-interfaces for SD-WAN.
   - Commits changes to Panorama and pushes configurations to managed Palo Alto devices.

2. **Palo Alto Configuration**
   - Associates VPC endpoints with Palo Alto devices in a specific region (east).

### Vars Files

The `vars_files` option loads environment-specific variables from the `sdwan_vars.yaml` file.

### Credential Retrieval

The playbook uses the `cyberark.pas.cyberark_credential` Ansible module to retrieve administrator credentials for Panorama devices from CyberArk. This ensures credentials are handled securely.

## Variables

The playbook uses a number of variables defined in `sdwan_vars.yaml` to configure the Panorama and Palo Alto devices:

- **Palo Alto Devices:**
  - List of devices with IP addresses, usernames, and serial numbers.
  - Example:
    ```yaml
    palo_alto_devices:
      - ip_address: 172.16.4.167
        username: admin
        name: Palo-dev-west-1a
        serial_number: '007955000395706'
        region: west
    ```

- **Panorama Configuration:**
  - Device group names, template names, and virtual router (VR) details for SD-WAN.
  - Example:
    ```yaml
    device_group_east: Palo Dev Gov East
    device_group_west: Palo Dev Gov West
    template_name: "Subinterface-Routing-Zone-TPL"
    vr_name: sdwan-vr
    ```

- **Security Rules:**
  - List of security rules to be created on the firewalls for SD-WAN traffic management.
  - Example:
    ```yaml
    security_rules:
      - rule_name: "{{ customer_name }}-sdwan-allow"
        source_ip:
          - '{{ customer_name }}-sdwan-east'
          - '{{ customer_name }}-sdwan-west'
        destination_ip:
          - "{{ customer_name }}-sdwan-east"
          - "{{ customer_name }}-sdwan-west"
        action: "allow"
    ```

- **Profiles:**
  - Security profiles such as antivirus, vulnerability, spyware, and URL filtering are used in security policies.
  - Example:
    ```yaml
    sdwan_antivirus_profile: 'default'
    sdwan_vulnerability_profile: 'strict'
    sdwan_spyware_profile: 'strict'
    sdwan_url_filtering_profile: 'default'
    ```

## Playbook Breakdown

### Panorama Configuration

The first part of the playbook retrieves credentials, sets up the Panorama environment, and applies configuration changes to the Panorama objects and policies:

1. **Credential Retrieval:**
   - Retrieves administrator credentials for Panorama from CyberArk.

2. **Create Panorama Objects:**
   - Configures objects and object groups for SD-WAN across `device_group_west` and `device_group_east`.

3. **Security Rules:**
   - Creates security policies for SD-WAN traffic, including rules for allowing IPsec, DTLS, and NETCONF traffic.

4. **Sub-interface Configuration:**
   - Configures the `ethernet1/3` interface on each device for SD-WAN with DHCP enabled.

5. **Commit and Push Configuration:**
   - Commits configuration changes to Panorama and pushes them to managed devices.

### Palo Alto Configuration

The second part of the playbook applies configurations to individual Palo Alto devices by associating VPC endpoints using region-based filters.

## Running the Playbook

To run the playbook:

```bash
ansible-playbook -i inventory.yaml panorama_sdwan_playbook.yaml
