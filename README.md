# hammerspoon-config

이 저장소는 macOS 자동화 도구인 Hammerspoon 설정(`init.lua`)을 관리합니다.

## Hammerspoon이란?

Hammerspoon은 macOS를 Lua 스크립트로 자동화할 수 있게 해주는 앱입니다.
운영체제 기능과 Lua 엔진을 연결해, 단축키/윈도우/오디오/이벤트 등을 코드로 제어할 수 있습니다.

- 공식 소개: https://www.hammerspoon.org/
- Getting Started: https://www.hammerspoon.org/go/
- API 문서: https://www.hammerspoon.org/docs/
- GitHub 저장소: https://github.com/Hammerspoon/hammerspoon

## 빠른 시작

1. Hammerspoon 설치
   - https://www.hammerspoon.org/ 에서 최신 버전을 내려받아 `/Applications`로 이동
2. 설정 열기
   - Hammerspoon 메뉴바 아이콘 -> `Open Config`
   - 설정 파일 위치: `~/.hammerspoon/init.lua`
3. 설정 반영(리로드)
   - 메뉴바 아이콘 -> `Reload Config`
   - 또는 기본 단축키(`cmd+ctrl+R`, 환경에 따라 다를 수 있음) 사용

## 이 저장소에서 문서를 어디서 보나?

- 사용자/기여자 관점 안내: `README.md` (이 문서)
- 에이전트 작업 규칙: `AGENTS.md`
- Claude용 경로: `CLAUDE.md` -> `AGENTS.md` (심볼릭 링크)

## 현재 저장소 구조

- `init.lua`: Hammerspoon 메인 설정 파일
- `AGENTS.md`: 에이전트 실행 기준 및 검증 정책
- `CLAUDE.md`: `AGENTS.md`를 가리키는 심볼릭 링크

## 실행/검증 메모

현재 저장소에는 별도 build/lint/test 스크립트가 없습니다.

```bash
ls -la
lua -e "assert(loadfile('init.lua'))"
```

`lua` 실행 파일이 없는 환경에서는 Hammerspoon에서 설정 Reload 후 수동 확인이 필요합니다.
