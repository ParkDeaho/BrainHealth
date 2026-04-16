/// 로컬 AI 시스템 프롬프트용 일반 참고 문구. 의학적 진단·처방을 대체하지 않는다.
class BrainHealthKnowledge {
  BrainHealthKnowledge._();

  static String koPlain() {
    return '''
뇌 건강 일반: 규칙적인 수면과 깨어 있는 시간의 리듬은 주의력과 기억에 도움이 될 수 있다. 가벼운 유산소 운동과 걷기는 혈류와 기분에 긍정적일 수 있다. 사회적 대화와 새로운 활동은 인지 자극과 연결될 수 있다. 균형 잡힌 식사와 수분 섭취는 전신 건강과 함께 뇌 건강 습관의 기반이 될 수 있다. 지속적인 스트레스는 집중과 수면을 흔들 수 있어 호흡·이완·짧은 휴식이 도움이 될 수 있다.

치매와 인지 건강: 이 앱은 치매나 다른 질환을 진단하지 않는다. 연령과 유전은 위험 요인으로 알려져 있으나 생활 습관도 중요하게 다뤄진다. 인지 예방을 위한 생활 습관으로는 혈압·혈당·콜레스테롤 관리, 금연·절주, 규칙적 활동, 사회 참여, 수면 확보 등이 일반적으로 언급된다. 앱의 측정 점수는 참고용이며 이상이 걱정되면 병원 진료가 필요하다.

집중력: 주의는 한 번에 오래 유지하기보다 짧은 구간으로 나누고 방해를 줄이는 것이 도움이 될 수 있다. 시각적으로 한 가지 과제에 몰입하는 연습은 Stroop·지속 주의 과제와 같은 형태로 훈련할 수 있다. 불안이 높을 때는 먼저 호흡으로 안정을 취한 뒤 짧은 집중 과제를 하는 순서가 나을 수 있다.

앱 과제와 인지 기능의 대략적 연결: 셈하기는 작업 기억과 간단한 계산 반응을 쓴다. 그림자 찾기는 시각적 비교와 패턴 일치를 쓴다. 미로 찾기는 경로 계획과 공간 추론을 쓴다. 이 설명은 교육용이며 개인의 능력을 평가하는 임상 도구가 아니다.
'''.trim();
  }

  static String enPlain() {
    return '''
General brain health: Regular sleep and a stable day-night rhythm can support attention and memory. Light aerobic activity and walking may support mood and circulation. Social contact and novel activities are often linked with cognitive stimulation. Balanced meals and hydration support overall health. Chronic stress can disrupt focus and sleep; breathing, relaxation, and short breaks may help.

Dementia and cognition: This app does not diagnose dementia or any disease. Age and genetics matter, but lifestyle is widely discussed too. Commonly cited habits include blood pressure, glucose, and cholesterol care, avoiding smoking, limiting alcohol, staying active, staying socially engaged, and protecting sleep. App scores are informational only; see a clinician if you are worried.

Focus: Attention often works better in short blocks with fewer distractions than in one long stretch. Tasks like Stroop or sustained-attention drills can practice staying on one rule. If anxiety is high, brief breathing before short focus tasks may feel easier.

In-app tasks (educational mapping, not clinical testing): Numeracy taps working memory and quick calculation. Shadow matching uses visual comparison. Mazes use path planning and spatial reasoning.
'''.trim();
  }
}
