class Daily {
  final String id;
  final double? sleepHrs;
  final int? mood;
  final bool memoryPlayed;
  final bool attentionPlayed;
  final bool languagePlayed;
  final bool mathPlayed;

  Daily({
    required this.id,
    this.sleepHrs,
    this.mood,
    required this.memoryPlayed,
    required this.attentionPlayed,
    required this.languagePlayed,
    required this.mathPlayed,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      id: json['id'],
      sleepHrs: json['sleepHrs'],
      mood: json['mood'],
      memoryPlayed: json['memoryPlayed'] ?? false,
      attentionPlayed: json['attentionPlayed'] ?? false,
      languagePlayed: json['languagePlayed'] ?? false,
      mathPlayed: json['mathPlayed'] ?? false,
    );
  }
}
