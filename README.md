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
- `sizeup/`
  - `init.lua`: SizeUp 동작·단축키 등록
  - `geometry.lua`: 창 프레임 계산 순수 함수
  - `feedback.lua`: 단축키 안내 메시지/알림 도우미
- `tests/`: Lua 단위 테스트 (`geometry_spec.lua`, `feedback_spec.lua`)
- `SHORTCUTS.md`: 단축키 표
- `AGENTS.md`: 에이전트 실행 기준 및 검증 정책
- `CLAUDE.md`: `AGENTS.md`를 가리키는 심볼릭 링크

## 실행/검증 메모

Lua 5.4 이상이 설치되어 있으면 아래 명령으로 구문·단위 테스트를 확인할 수 있습니다.

```bash
# init.lua 구문 확인
lua -e "assert(loadfile('init.lua'))"

# 순수 함수 단위 테스트
lua tests/geometry_spec.lua
lua tests/feedback_spec.lua
```

`lua` 실행 파일이 없다면 Hammerspoon에서 설정을 Reload 하여 실제 단축키 동작을 수동 검증해야 합니다. 필요 시 `brew install lua` 로컬 설치를 권장합니다.

## 개발 환경 준비

SizeUp 스크립트와 단위 테스트를 실행하려면 Lua 5.4+가 필요합니다. Homebrew를 사용한다면 아래 명령으로 설치합니다.

```bash
brew install lua
lua -v  # 설치 확인
```

설치 후에는 `lua -e "assert(loadfile('init.lua'))"`와 `lua tests/*.lua`를 통해 바로 구문/단위 테스트를 실행할 수 있습니다.

## SizeUp 스타일 단축키 안내

- 모든 창 이동/크기 조절/스냅백/모니터 이동 단축키는 실행 즉시 해당 모니터 화면 중앙에 한국어 안내(`hs.alert`)를 0.4초 동안 보여 줍니다.
- `init.lua`에서 `sizeup.setup({ alert = { duration = 0.6, style = { textSize = 24 } } })`와 같이 호출하면 안내 표시 시간이나 폰트 크기를 조정할 수 있습니다. 메시지 문구를 변경하려면 `alert.messages` 테이블에 `left = "..."`와 같이 원하는 텍스트를 지정하면 됩니다.
- 중앙 배치 메시지는 현재 설정된 절대/상대 크기에 맞게 자동으로 업데이트됩니다.
- macOS Mission Control Space 이동은 안정적으로 지원되지 않아 단축키에서 제외했습니다. 필요하다면 macOS 기본 키보드 설정을 이용해 주세요.
