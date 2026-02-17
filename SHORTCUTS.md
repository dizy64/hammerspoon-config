# SizeUp 스타일 단축키

SizeUp 앱의 `Shortcuts` 탭을 기준으로 동일/유사한 단축키를 Hammerspoon으로 재현했습니다.
키 순서는 `Ctrl(⌃) + Option(⌥) + Command(⌘)` 등을 한글 표기로 설명합니다. 모든 조작 시 현재 모니터 중앙에 동작명이 0.4초간 표시되어 시각적으로 확인할 수 있습니다.

## Split Screen Actions

| 기능 | 단축키 | 설명 |
| --- | --- | --- |
| Send Window Left | `Ctrl+Option+Command+←` | 활성 창을 현재 모니터 왼쪽 절반으로 이동 |
| Send Window Right | `Ctrl+Option+Command+→` | 활성 창을 현재 모니터 오른쪽 절반으로 이동 |
| Send Window Up | `Ctrl+Option+Command+↑` | 활성 창을 위쪽 절반으로 이동 |
| Send Window Down | `Ctrl+Option+Command+↓` | 활성 창을 아래쪽 절반으로 이동 |

## Quarter Screen (Quadrant) Actions

| 기능 | 단축키 | 설명 |
| --- | --- | --- |
| Send Window Upper Left | `Ctrl+Option+Shift+Command+U` | 좌상단 사분면 배치 |
| Send Window Upper Right | `Ctrl+Option+Shift+Command+I` | 우상단 사분면 배치 |
| Send Window Lower Left | `Ctrl+Option+Shift+Command+J` | 좌하단 사분면 배치 |
| Send Window Lower Right | `Ctrl+Option+Shift+Command+K` | 우하단 사분면 배치 |

> U/I/J/K 배열을 통해 키보드 홈 포지션에서 쉽게 대각선을 구분할 수 있도록 선택했습니다.

## Multiple Monitor Actions

| 기능 | 단축키 | 설명 |
| --- | --- | --- |
| Send Window Prev. Monitor | `Ctrl+Option+←` | 이전 모니터로 창을 이동 (비율 유지) |
| Send Window Next Monitor | `Ctrl+Option+→` | 다음 모니터로 창을 이동 (비율 유지) |

## SnapBack / 기타

| 기능 | 단축키 | 설명 |
| --- | --- | --- |
| SnapBack Window | `Ctrl+Option+Command+/` | 직전에 저장된 창 위치·크기로 복귀 (토글) |
| Make Window Full Screen | `Ctrl+Option+Command+M` | 창을 화면에 맞춰 최대화(시스템 전체화면 아님) |
| Send Window Center | `Ctrl+Option+Command+C` | 창을 화면 중앙 800×600 크기로 배치 |

## 설정 커스터마이징

- `init.lua` 에서 `sizeup.setup({ center = { ... } })` 값으로 중앙 배치 크기를 절대/상대 모드로 조정할 수 있습니다.
- 다른 단축키를 쓰고 싶다면 `sizeup/init.lua` 의 `defaultBindings` 테이블을 참고하여 원하는 조합을 전달하거나, `sizeup.setup({ bindings = { ... } })`에 새 목록을 넘기면 됩니다.
- 안내 문구/표시 시간/폰트는 `sizeup.setup({ alert = { duration = 0.6, style = { textSize = 24 }, messages = { left = "좌측" } } })`와 같이 커스터마이즈할 수 있습니다.
- macOS Mission Control Space 이동은 Hammerspoon 공식 API에서 안정적으로 지원되지 않으므로 이번 구성에서는 제외했습니다. 필요 시 macOS 기본 키보드 설정으로 이동 단축키를 설정하세요.
