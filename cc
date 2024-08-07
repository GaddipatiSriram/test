- name: Fetch AWS ACM certificate details
  amazon.aws.aws_acm_facts:
    region: us-gov-west-1
    cross_account_role_arn: '{{ acm_iam_role_arn }}'
    role_session_name: midserver_acm_session
  register: acm_facts

- name: Find the certificate by domain name
  ansible.builtin.set_fact:
    certificate_arn: "{{ item.certificate_arn }}"
  loop: "{{ acm_facts.certificates }}"
  when: "{{ gitlab_cert_domain }} in item.domain_name"

- name: Get the certificate
  amazon.aws.aws_acm_certificate_info:
    certificate_arn: "{{ certificate_arn }}"
    region: '{{ region }}'
  register: cert_info
  when: certificate_arn is defined

- name: Write certificate to file
  ansible.windows.win_copy:
    content: "{{ cert_info.certificate }}"
    dest: "C:\\tmp\\gitlab-cert.pem"
    mode: '0644'
  when: cert_info is defined

- name: Import Certificate into Java Keystore
  vars:
    cert_path: "C:\\tmp\\gitlab-cert.pem"
    keystore_path: "{{ mid_install_location }}\\ServiceNow MID Server {{ host_name }}\\agent\\jre\\lib\\security\\cacerts"
    alias_name: "gitlab.private"
  block:
    - name: Copy certificate to target location
      ansible.windows.win_copy:
        src: "C:\\tmp\\gitlab-cert.pem"
        dest: "{{ cert_path }}"
        mode: '0644'

    - name: Import certificate into Java Keystore
      ansible.windows.win_command: >
        "{{ mid_install_location }}\\ServiceNow MID Server {{ host_name }}\\agent\\jre\\bin\\keytool.exe"
        -import -trustcacerts -alias {{ alias_name }}
        -file "{{ cert_path }}"
        -keystore "{{ keystore_path }}"
        -storepass changeit
        -noprompt
      ignore_errors: yes

    - name: Check if certificate was imported
      ansible.windows.win_shell: >
        "{{ mid_install_location }}\\ServiceNow MID Server {{ host_name }}\\agent\\jre\\bin\\keytool.exe"
        -list -alias {{ alias_name }}
        -keystore "{{ keystore_path }}"
        -storepass changeit
      register: keytool_result
      ignore_errors: yes

    - name: Fail if certificate import failed
      ansible.builtin.fail:
        msg: "Failed to import certificate"
      when: "'trustedCertEntry' not in keytool_result.stdout"
