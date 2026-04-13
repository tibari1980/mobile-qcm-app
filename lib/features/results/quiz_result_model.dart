// Model for Quiz Results

class QuizResult {
  final String id;
  final DateTime date;
  final int score;
  final int total;
  final String theme;
  final String path; // NAT, CR, CSP
  final int durationSeconds;

  QuizResult({
    required this.id,
    required this.date,
    required this.score,
    required this.total,
    required this.theme,
    required this.path,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'score': score,
    'total': total,
    'theme': theme,
    'path': path,
    'durationSeconds': durationSeconds,
  };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    id: json['id'],
    date: DateTime.parse(json['date']),
    score: json['score'],
    total: json['total'],
    theme: json['theme'],
    path: json['path'],
    durationSeconds: json['durationSeconds'] ?? 0, // Fallback for old records
  );
  
  double get precision => total > 0 ? (score / total) * 100 : 0;
}
