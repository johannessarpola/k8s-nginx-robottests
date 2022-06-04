
.PHONY: add-registry
add-registry:
		helm repo add bitnami https://charts.bitnami.com/bitnami"

.PHONY: install-minio
install-minio:
		helm repo update
		helm install minio bitnami/minio -f .\helm\minio-bitnami-values.yaml

.PHONY: uninstall-minio
uninstall-minio:
		helm uninstall minio

.PHONY: delete-jobs
delete-jobs:
		kubectl delete --all jobs
		kubectl delete --all cronjobs

.PHONY: create-jobs
create-jobs:
		kubectl apply -f k8s/robot-batchjob.yaml
		kubectl apply -f k8s/robot-cronjob.yaml

.PHONY: restart-html
restart-html:
		 kubectl rollout restart deployment/nginx-reports-deployment