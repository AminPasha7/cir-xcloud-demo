#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../infra/aws"
terraform destroy -auto-approve
