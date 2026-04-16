class MindCheckState {
  final int mood;
  final int stress;
  final int anxiety;
  final int motivation;
  final double? sleepHours;
  final String note;
  final bool isSaved;

  const MindCheckState({
    this.mood = 3,
    this.stress = 3,
    this.anxiety = 3,
    this.motivation = 3,
    this.sleepHours,
    this.note = '',
    this.isSaved = false,
  });

  MindCheckState copyWith({
    int? mood,
    int? stress,
    int? anxiety,
    int? motivation,
    double? sleepHours,
    String? note,
    bool? isSaved,
  }) {
    return MindCheckState(
      mood: mood ?? this.mood,
      stress: stress ?? this.stress,
      anxiety: anxiety ?? this.anxiety,
      motivation: motivation ?? this.motivation,
      sleepHours: sleepHours ?? this.sleepHours,
      note: note ?? this.note,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
