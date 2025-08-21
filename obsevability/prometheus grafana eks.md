#Creating Monitoring for EKS using Prometheus and Grafana


### Create EKS

`eksctl create cluster --name=observability \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --without-nodegroup`
                
### OIDC Provider

`eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster observability \
    --approve`


### Create Node Group

`eksctl create nodegroup --cluster=observability \
                        --region=us-east-1 \
                        --name=observability-ng-private \
                        --node-type=t3.medium \
                        --nodes-min=2 \
                        --nodes-max=3 \
                        --node-volume-size=20 \
                        --managed \
                        --asg-access \
                        --external-dns-access \
                        --full-ecr-access \
                        --appmesh-access \
                        --alb-ingress-access \
                        --node-private-networking


### Update ./kube/config file`

`aws eks update-kubeconfig --name observability`


### Pull kube-prometheus-stack

`helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update`


### Create Name Space 

`kubectl create ns monitoring`


### Install kube-prometheus-stack

`helm install monitoring prometheus-community/kube-prometheus-stack \
-n monitoring \
-f alertmanager.yml`


### Verify the Installation

`kubectl get all -n monitoring`

### Expose port to access th UI
`
kubectl port-forward service/prometheus-operated -n monitoring 9090:9090

kubectl port-forward service/monitoring-grafana -n monitoring 8080:80

kubectl port-forward service/alertmanager-operated -n monitoring 9093:9093`


### Uninstall resources
`
helm uninstall monitoring --namespace monitoring

kubectl delete ns monitoring

eksctl delete cluster --name observability`