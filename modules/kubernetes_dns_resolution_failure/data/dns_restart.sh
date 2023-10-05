

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