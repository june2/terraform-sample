# AWS Client VPN

## 세팅

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
## AWS Client VPN 구성 순서

- 참고자료 :
  - AWS Client VPN GSuite SAML Integration https://www.youtube.com/watch?v=kYJaHankFAg
- Certificate Manager 에서 VPN용 인증서 생성
- AWS SSO Application 구성
- IAM Identity Provider 구성
- Client VPN Endpoint 구성
  - Target network associations 구성
  - Authorization Ruls 구성
- SSO Application - 사용자및 그룹 추가
- SSO Application - Attribute mappings
- SSO Application - Assigned Users
- 접속하려는 PC에서 Client VPN Endpoint 구성정보 다운로드
- AWS Client VPN 다운로드 : https://aws.amazon.com/ko/vpn/client-vpn-download/
- 프로그램 실행후, 구성정보를 프로필에 등록
- 대상 VPN 접속 확인

## 주의사항
- Client VPN Endpoint 구성시 [Enable split-tunnel] 체크박스 반드시 선태할것.
