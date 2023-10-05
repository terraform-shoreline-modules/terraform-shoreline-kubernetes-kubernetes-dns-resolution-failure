
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes - DNS Resolution Failure
---

DNS resolution failure is a common incident type that occurs when services are unable to resolve domain names into IP addresses, leading to communication failure. DNS (Domain Name System) is responsible for translating human-readable domain names into machine-readable IP addresses. When this translation fails, services are unable to communicate with each other, resulting in outages or performance degradation. This incident type can be caused by various factors such as misconfigured DNS settings, DNS server failures, network connectivity issues, or cyber attacks.

### Parameters
```shell
export DNS_NAME="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export DNS_SERVER_IP="PLACEHOLDER"

export EXAMPLE_COM="PLACEHOLDER"

export DNS_SERVER_DEPLOYMENT_NAME="PLACEHOLDER"
```

## Debug

### Check if the kube-dns service is running
```shell
kubectl get svc kube-dns -n kube-system
```

### View the logs of the kube-dns pod
```shell
kubectl logs ${POD_NAME} -n kube-system
```

### Check if the DNS service IP is correctly set
```shell
kubectl get svc kube-dns -n kube-system -o jsonpath='{.spec.clusterIP}{"\n"}'
```

### Check if the DNS pod is running and ready
```shell
kubectl get pods -n kube-system -l k8s-app=kube-dns
```

### Check if the DNS configuration is correct
```shell
kubectl exec ${POD_NAME} -n kube-system -- cat /etc/resolv.conf
```

### Check if the DNS server is reachable from the cluster
```shell
kubectl run -it --rm dnsutils --image=tutum/dnsutils --restart=Never -- nslookup ${DNS_NAME}
```

### Check if the DNS resolution is working for a specific pod
```shell
kubectl exec ${POD_NAME} -- nslookup ${DNS_NAME}
```

### Check the DNS server configuration and ensure that it is configured correctly. Verify that the DNS server is operational and responding to queries.
```shell


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


```

## Repair

### Restart the DNS server to clear any cache or temporary issues.
```shell


#!/bin/bash



# Set the DNS server deployment name

deployment_name=${DNS_SERVER_DEPLOYMENT_NAME}



# Retrieve the current number of replicas

replicas=$(kubectl get deployment $deployment_name -o jsonpath='{.spec.replicas}')



# Scale the deployment down to 0 replicas

kubectl scale deployment $deployment_name --replicas=0



# Wait for the deployment to be fully scaled down

while [[ $(kubectl get deployment $deployment_name -o jsonpath='{.status.readyReplicas}') -ne 0 ]]; do

    sleep 5

done



# Scale the deployment back up to the original number of replicas

kubectl scale deployment $deployment_name --replicas=$replicas



# Wait for the deployment to be fully scaled up

while [[ $(kubectl get deployment $deployment_name -o jsonpath='{.status.readyReplicas}') -ne $replicas ]]; do

    sleep 5

done



echo "DNS server deployment has been restarted."


```