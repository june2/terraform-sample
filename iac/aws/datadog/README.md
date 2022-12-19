# DataDog prod, dev, staging 환경 구성

# AWS EKS for DataDog DaemonSet 구성

- RBAC 구성 : https://docs.datadoghq.com/containers/cluster_agent/setup/?tab=daemonset#pagetitle
- DataDog Agent 데몬셋 설치 : https://docs.datadoghq.com/containers/kubernetes/installation/?tab=daemonset&tabs=daemonset (설치 이후 다음 RBAC 관련 설치)

# AWS EC2 for DataDog RDS Agent Terraform 구성

- 각 workspace 이름별로 환경이 생성됩니다. 아래 명령어로 생성할 환경에 대해 먼저 workspace를 세팅해주세요

```bash
# 각 환경별 workspace 생성
$ terraform workspace new dev
$ terraform workspace new prod
$ terraform workspace new staging

# dev 기준 환경세팅시
$ terraform workspace select dev
$ terraform init
$ terraform fmt
$ terraform validate
$ terraform plan
$ terraform apply
```
- EC2 생성이후 AWS의 System Mamanger -> Session Manager로 linux terminal 접속하거나 VPN을 통한 내부IP terminal 접속.
- 시간대역 설정 
```bash
sudo timedatectl set-timezone Asia/Seoul
```
- 다음 링크를 참조하여 RDS Agent 설치
# AWS RDS monitoring
https://docs.datadoghq.com/database_monitoring/setup_mysql/aurora?tab=mysql57

# AWS RDS integrations
https://docs.datadoghq.com/integrations/amazon_rds/?tab=native

# DataDog Agent Installation
https://app.datadoghq.com/account/settings#agent
  -> 왼편 툴 메뉴에서 Amazon Linux 선택

# DatDog yaml파일 위치
* Adding your API key to the Datadog Agent configuration: /etc/datadog-agent/datadog.yaml
* Setting SITE in the Datadog Agent configuration: /etc/datadog-agent/datadog.yaml

# 기본 명령어

- 중지 : sudo systemctl stop datadog-agent
- 기동 : sudo systemctl start datadog-agent
- Agent 주요 CLI 명령어 : https://docs.datadoghq.com/agent/basic_agent_usage/amazonlinux/?tab=agentv6v7