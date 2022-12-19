# mosaic-square-infra

Reposioty for IaC and GitOps

## iac

- iac folder - terraform code for Infra
- 폴더별 설명

  ```bash
  aws
  ├── eks
  │   └── spec-file
  │
  ├── global
  │   └── base
  │
  ├── ingress-rule
  │   └── spec-file
  │
  └── monitoring
      └── spec-file
          └── argocd
  ```

  - aws/eks

    - spec-file folder
      - 각종 yml 파일
    - 각 서비스 환경별(prod/staging/dev) vpc, eks 생성 및 설정
    - prometheus-grafana 설치
    - metrics-server 설치(hpa 를 위함)

  - aws/global

    - terraform backend 파일의 s3에 저장
    - terraform 소스적용에 대해 dynamo db를 통한 lock 기능 설정

  - aws/ingress-rule

    - 각 서비스 환경별(prod/staging/dev) ingress 설정
    - 모니터링 환경은 제외 되었으며 monitoring폴더에서 따로 설정
    - route 53 설정

  - aws/monitoring
    - spec-file folder
      - 각종 yml 파일
    - monitoring eks 생성
    - argocd/argo-rollout 설치
    - ingress 설정
    - route 53설정
    - metrics-server 설치(hpa 를 위함)
