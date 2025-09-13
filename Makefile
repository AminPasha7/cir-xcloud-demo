AWS_PROFILE?=default
GCP_PROJECT?=CHANGE_ME
REGION?=us-central1
setup:
    cd infra/aws && terraform init && terraform apply -auto-approve
    cd infra/gcp && terraform init && terraform apply -auto-approve
deploy_gcp_service:
    gcloud builds submit src --tag gcr.io/$(GCP_PROJECT)/cir-translator
    gcloud run deploy cir-translator --image gcr.io/$(GCP_PROJECT)/cir-translator --region $(REGION) --allow-unauthenticated
cleanup:
    cd infra/aws && terraform destroy -auto-approve
    cd infra/gcp && terraform destroy -auto-approve
