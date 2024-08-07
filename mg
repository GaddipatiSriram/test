"C:\Program Files\ServiceNow MID Server mid-api01-west-dev\agent\jre\bin\keytool.exe" -list -keystore "C:\Program Files\ServiceNow MID Server mid-api01-west-dev\agent\jre\lib\security\cacerts"


# Trying with JKS format
"C:\Program Files\ServiceNow MID Server mid-api01-west-dev\agent\jre\bin\keytool.exe" -list -keystore "C:\Program Files\ServiceNow MID Server mid-api01-west-dev\agent\jre\lib\security\cacerts" -storetype JKS

# Trying with PKCS12 format
"C:\Program Files\ServiceNow MID Server mid-api01-west-dev\agent\jre\bin\keytool.exe" -list -keystore "C:\Program Files\ServiceNow MID Server mid-api01-west-dev\agent\jre\lib\security\cacerts" -storetype PKCS12

"C:\Program Files\ServiceNow MID Server mid-api01-west-dev\agent\jre\bin\keytool.exe" -importcert -alias gitlab.private -file "c:\gitlab-cert.pem" -keystore "new-cacerts.jks" -storetype JKS
