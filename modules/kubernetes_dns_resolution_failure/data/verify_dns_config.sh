

#!/bin/bash



# Set the DNS server IP address

DNS_SERVER=${DNS_SERVER_IP}



# Verify that the DNS server is operational and responding to queries

ping -c 5 $DNS_SERVER

if [ $? -ne 0 ]; then

    echo "DNS server is not responding"

    exit 1

fi



# Check the DNS server configuration

nslookup google.com $DNS_SERVER

if [ $? -ne 0 ]; then

    echo "DNS server configuration is incorrect"

    exit 1

fi



echo "DNS server configuration is correct"