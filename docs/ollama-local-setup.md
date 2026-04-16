# 로컬 Ollama 설정 (BrainTrain Flutter)

앱의 **로컬 AI** 화면은 인터넷 API가 아니라 같은 네트워크(또는 이 기기)에서 돌아가는 [Ollama](https://ollama.com) HTTP API(`http://<호스트>:11434`)만 사용합니다.

## 1. Ollama 설치·실행 (Windows)

1. [ollama.com](https://ollama.com)에서 Windows용 설치 후 실행합니다.
2. 작업 표시줄 **트레이에 Ollama 아이콘**이 있거나, 터미널에서 `ollama serve`가 동작 중이어야 합니다.
3. 최소 한 개 모델을 받습니다. 예:

   ```bash
   ollama pull llama3.2
   ```

4. PC 브라우저나 터미널에서 확인합니다.

   ```bash
   curl http://127.0.0.1:11434/api/tags
   ```

   JSON이 오면 정상입니다.

### 저장소 스크립트로 확인 (Windows PowerShell)

프로젝트 루트에서:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check-ollama.ps1
```

다른 주소를 쓰는 경우:

```powershell
powershell -File scripts/check-ollama.ps1 -BaseUrl "http://10.0.2.2:11434"
```

## 2. 앱 설정

- **기본 주소:** `http://127.0.0.1:11434` (앱 기본값과 동일)
- **기본 모델:** `llama3.2` — `ollama pull`로 받은 이름과 맞추세요.
- 설정은 앱 **로컬 AI → 톱니(설정)** 에서 바꿀 수 있습니다.

### Android 에뮬레이터

호스트 PC의 Ollama에 붙으려면 `127.0.0.1` 대신 **`http://10.0.2.2:11434`** 를 사용합니다.

### 실제 Android 기기 (USB/같은 Wi‑Fi)

PC 방화벽에서 11434 허용 후, PC의 **LAN IP**(예: `http://192.168.0.10:11434`)를 입력합니다.

## 3. 자주 나는 오류 (Windows `errno = 1225`)

**“연결 거부(connection refused)”** 는 보통 아래 중 하나입니다.

- Ollama가 **실행 중이 아님** → 트레이에서 실행 또는 `ollama serve`
- **다른 포트**에 떠 있음 → 브라우저/설정에서 실제 주소 확인
- 에뮬레이터인데 **`127.0.0.1`만 씀** → `10.0.2.2:11434`로 변경

앱에서는 긴 예외 대신 짧은 안내 문구로 표시되도록 되어 있습니다. 그래도 채팅이 안 되면 위 순서대로 PC에서 Ollama가 먼저 응답하는지 확인하세요.
