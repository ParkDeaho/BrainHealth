import 'package:flutter/foundation.dart';

/// [TestResultRecorder]가 기록을 넣을 때마다 증가시켜, 리포트·홈 등이 목록을 다시 불러오게 합니다.
class TestRecordEvents {
  TestRecordEvents._();

  static final ValueNotifier<int> bump = ValueNotifier<int>(0);

  static void notifyRecorded() {
    bump.value++;
  }
}
