# Base

## Terraform Backend 관리 설정

- S3 에 terraform state 이 upload 됩니다.
  - bucket 명: `mos-terraform-infra`
- aws dynamo db 를 통한 terraform 실적용에 대한 lock 기능 설정이 됩니다.
