# Flutter MVP 아키텍처 가이드 (BrainFit / BrainTrain)

이 문서는 **웹(Vite/React) 프로토타입**과 동일한 도메인을 Flutter로 옮길 때의 권장 구조입니다.  
서버 없이 로컬 중심으로 출시하되, **강제 업데이트만 외부 기준값**을 쓰는 정책과 맞춥니다.

---

## 1. 추천 스택 (최종)

| 영역 | 추천 |
|------|------|
| UI | Flutter |
| 상태관리 | **Riverpod** |
| 로컬 DB | **Drift** (SQLite, 타입·마이그레이션 유리) |
| 단순 키-값 설정 | **SharedPreferences** |
| 광고 | **google_mobile_ads** |
| 강제 업데이트 | **Firebase Remote Config** 또는 **작은 JSON** (정적 호스팅) |
| 라우팅 | **go_router** (또는 Navigator 2) |
| 앱 버전 | **package_info_plus** |
| 스토어 열기 | **url_launcher** |
| HTTP | **dio** 또는 **http** |

**초기 MVP에 과도한 레이어는 피하고**, 아래 조합부터 시작하는 것을 권장합니다.

- Riverpod + Drift + SharedPreferences + JSON 버전 파일(또는 Remote Config)

---

## 2. Hive vs sqflite vs Drift

- **Hive**: 빠르고 단순. 관계·복잡 쿼리·마이그레이션이 늘면 부담.
- **sqflite**: 익숙한 SQL. 보일러플레이트·유지보수 비용 증가.
- **Drift** (추천): SQLite 기반, Dart 타입 안전, 쿼리/DAO/마이그레이션 정리에 유리.  
  문진·테스트·훈련·일별 요약처럼 **테이블이 늘어나는 앱**에 적합.

---

## 3. `lib/` 폴더 구조 (권장)

```
lib/
├── app/
│   ├── router/
│   ├── theme/
│   └── constants/
├── core/
│   ├── utils/          # 버전 비교 등
│   ├── services/       # UpdateCheckService 등
│   ├── widgets/
│   └── config/
├── data/
│   ├── local/
│   │   ├── db/         # Drift database
│   │   ├── dao/
│   │   └── tables/
│   ├── models/
│   ├── repositories/
│   └── sources/
├── domain/
│   ├── entities/
│   ├── usecases/
│   └── repositories/   # 인터페이스만 (구현은 data)
├── features/
│   ├── splash/
│   ├── onboarding/
│   ├── home/
│   ├── questionnaire/
│   ├── test/
│   ├── training/
│   ├── report/
│   ├── mypage/
│   └── update/         # 강제 업데이트 전용 (분리 권장)
└── main.dart
```

**역할 분리**

- **data**: Drift, SharedPreferences, 원격 JSON fetch.
- **domain**: 점수 계산, 인사이트 생성 등 순수 로직.
- **features**: 화면·라우트 단위.
- **core**: 공통 위젯·버전 유틸·원격 설정 클라이언트.

---

## 4. 로컬 DB에 넣을 항목

웹/서버 설계와 동일한 최소 세트를 권장합니다.

### 필수 (MVP)

- `user_profile`
- `daily_condition`
- `questionnaire_result` (초기에는 `answered_json` 등 TEXT로 묶어도 됨)
- `test_result` (`detail_json`으로 이벤트 로그 대체 가능)
- `training_result`
- `daily_score_summary`
- `app_config_cache` (원격 버전/설정 JSON 캐시)

### 추천 추가 (성장 시)

- `questionnaire_answer_detail`
- `test_event_log`
- `insight_report_cache`

이 저장소의 **SQLite 초안**은 `database/local_mvp.sql`을 참고하면 됩니다. Drift 테이블 정의 시 컬럼을 맞추면 웹·앱 간 데이터 모델 일관성을 유지하기 쉽습니다.

---

## 5. 강제 업데이트 (외부 기준 필수)

로컬 DB만으로는 **“최소 지원 버전”**을 알 수 없습니다. 다음 중 하나가 필요합니다.

### 방안 A: Firebase Remote Config

- `latest_version`, `min_required_version`, `force_update`, `store_url`, `update_message` 등.

### 방안 B: 작은 JSON (추천: 단순·의존성 적음)

예시 형태 (Android 블록):

```json
{
  "android": {
    "latestVersion": "1.0.5",
    "minRequiredVersion": "1.0.3",
    "forceUpdate": true,
    "storeUrl": "market://details?id=com.example.app",
    "message": "최신 버전으로 업데이트 후 이용해주세요."
  }
}
```

웹 프로토타입의 정적 예시는 `public/app-config/version.json`을 참고할 수 있습니다.  
**버전 비교는 문자열 정렬이 아니라 숫자 세그먼트 비교**가 필요합니다 (예: `1.0.10` > `1.0.9`).

---

## 6. 앱 실행 흐름 (Splash)

1. `SplashPage`에서 `PackageInfo.fromPlatform()`으로 현재 버전 로드.
2. `VersionConfigRepository`가 Remote Config 또는 JSON을 fetch → 실패 시 **로컬 캐시**(`app_config_cache`) 사용.
3. `compareVersion(current, minRequired) < 0` 이면 **`ForceUpdatePage`**만 표시 (뒤로가기/닫기 비활성, 스토어만).
4. 그렇지 않으면 온보딩 여부에 따라 홈 또는 온보딩.

**오프라인**: 마지막으로 성공한 캐시가 있으면 그 기준으로 판단.  
강제 업데이트 대상인데 오프라인이면 **차단** 정책을 택할지, 일시 허용할지는 제품 정책으로 결정.

---

## 7. `pubspec.yaml` 의존성 예시

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.0.0
  drift: ^2.0.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.0.0
  path: ^1.8.0
  shared_preferences: ^2.0.0
  package_info_plus: ^8.0.0
  url_launcher: ^6.0.0
  google_mobile_ads: ^5.0.0
  dio: ^5.0.0
  go_router: ^14.0.0

  # Firebase 사용 시
  # firebase_core: ^3.0.0
  # firebase_remote_config: ^5.0.0
```

---

## 8. Repository·Manager 분리 (서버 전환 대비)

| 구분 | 예시 |
|------|------|
| 로컬 데이터 | `LocalDbRepository` / feature별 `QuestionnaireRepository` 인터페이스 |
| 버전·원격 설정 | `VersionConfigRepository` |
| 비즈니스 로직 | `ScoreCalculator`, `InsightGenerator`, `UpdateCheckService` |

초기 구현: `LocalQuestionnaireRepository` (Drift).  
이후: 동일 인터페이스에 `RemoteQuestionnaireRepository`만 교체.

---

## 9. MVP 개발 순서 (권장)

1. 프로젝트 뼈대, Riverpod, Drift, 테마, 라우팅(`go_router`).
2. Splash + **버전 게이트** + 온보딩 + 홈 + 일일 체크인 + 문진 + 테스트 2종 + 로컬 저장.
3. 훈련 게임, 점수 계산, 리포트.
4. 광고, 강제 업데이트 정책 다듬기, 설정 화면.
5. 베타·실사용 테스트.

---

## 10. 이 저장소와의 대응 관계

| Flutter 쪽 | 이 repo (웹) |
|------------|----------------|
| Drift 스키마 | `database/local_mvp.sql`, `database/schema.sql` |
| 버전 JSON | `public/app-config/version.json` 형식 참고 |
| API/DTO 타입 (향후) | `src/types/api.ts` |
| 버전 파싱 개념 | `src/utils/version.ts`와 동일한 규칙 권장 |

---

## 11. 강제 업데이트 UI 정책

- **강제**: 뒤로가기/닫기 없음, 업데이트 버튼만, 메인 플로우 진입 차단.
- **선택 업데이트**: “나중에”, “오늘 하루 안 보기” 등 (Remote Config 플래그로 분리).

이 문서는 제품 결정에 따라 수시로 갱신하면 됩니다.
