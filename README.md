# Godot Work 실행 검증

Godot **4.7.2 일반판**으로 만든 작은 2D 물리 검증 프로젝트입니다.

## 구성

- `source/`: Godot 프로젝트 원본. 편집기에서 `source/project.godot`을 엽니다.
- `dist/`: Sites에서 실행 확인한 웹 로더와 게임 데이터. 압축 엔진은 별도 복원합니다.
- `tools/prepare_web_engine.py`: 동일 버전 Web nothreads release 템플릿에서 웹 엔진 복원.

## 확인된 결과

- Linux headless 및 독립 Linux 릴리스에서 중력·바닥 충돌 시험 통과.
- Web nothreads 릴리스 빌드 성공, Sites 배포 후 사용자 브라우저에서 PASS 확인.
- 현재 웹 소스는 120 물리 프레임 뒤 PASS/FAIL을 표시하며 자동 종료하지 않습니다.
- 이 Work의 원격 브라우저는 WebGL2 미지원으로 웹 편집기를 실행하지 못했습니다.
- Codex Cloud에서 GUI·가상 화면·WebGL2 동작 여부는 아직 검증하지 않았습니다.

## Codex Cloud / Linux

같은 버전의 일반 Linux 엔진을 설치한 후 실행합니다. `godot`은 해당 실행 파일을 뜻합니다.

```sh
godot --version
godot --headless --path source --import
godot --headless --path source --quit-after 240
```

로그의 `PHYSICS_PASS`를 확인합니다. `--quit-after`는 렌더 프레임 기준이므로 장비에 따라 종료 전에 120 물리 프레임이 안 지났다면 더 큰 값으로 실행합니다. 종료 코드만으로 PASS를 판정하지 않습니다.

## 기존 웹 빌드 실행

Godot 4.7.2 `web_nothreads_release.zip`을 준비합니다.

```sh
python3 tools/prepare_web_engine.py /path/to/web_nothreads_release.zip
python3 -m http.server 8000 --directory dist
```

`dist/engine-v2.wasm.gz`는 HTTP Content-Encoding을 강제하지 않고 gzip 파일 그대로 제공합니다. 로더가 직접 압축을 풀고 WebAssembly를 초기화합니다.

## 웹 재빌드

`templates/web_nothreads_debug.zip`과 `templates/web_nothreads_release.zip`을 준비합니다.

```sh
mkdir -p build
godot --headless --path source --export-release Web ../build/index.html
```

새 결과물은 `build/`에 생성합니다. 기존 `dist/index.html`·`dist/index.js`에는 단계·용량·시간·실패 표시 및 명시적 gzip 해제 수정이 있으므로 덮어쓰지 말고 새 엔진/게임 데이터와 함께 검토합니다.

엔진 실행 파일과 export templates, Sites 배포 ID·자격증명은 포함하지 않았습니다. GitHub 변경은 기존 Sites로 자동 배포되지 않습니다.
