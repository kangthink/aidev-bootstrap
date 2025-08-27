# AI Development Bootstrap

🚀 빠른 AI 개발 프로젝트 부트스트랩 도구

## 사용법

### 원클릭 설치 (추천)

```bash
# 기본 프로젝트명으로 생성
curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash

# 커스텀 프로젝트명으로 생성
curl -fsSL https://raw.githubusercontent.com/kangthink/aidev-bootstrap/main/install-simple.sh | bash -s -- my-ai-project
```

### 로컬에서 실행

```bash
# 저장소 클론
git clone https://github.com/kangthink/aidev-bootstrap.git
cd aidev-bootstrap
```

## 포함되는 폴더

- `.claude/` - Claude Code 설정 및 워크플로우
- `scripts/` - 개발 스크립트 및 유틸리티

## 요구사항

- Git
- Bash
- curl

## 커스터마이징

`install-simple.sh`의 22번째 줄을 수정하여 복사할 폴더를 변경:

```bash
for folder in .claude scripts; do
    # 원하는 폴더명 추가
```

## 라이선스

MIT