class QuizQuestion {
  final String id;
  final String question;
  final List<String> choices;
  final int answerIndex;
  final String explanation;
  final String theme;
  final String level;
  final List<String> parcours; // NEW: Path indicators (CSP, CR, NAT)

  QuizQuestion({
    required this.id,
    required this.question,
    required this.choices,
    required this.answerIndex,
    required this.explanation,
    required this.theme,
    required this.level,
    this.parcours = const ['NAT'], // Default to most inclusive if missing
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id']?.toString() ?? 'q_err_${DateTime.now().millisecondsSinceEpoch}';
      final question = json['question']?.toString() ?? 'Question manquante';
      
      final List<String> choices = [];
      final choicesRaw = json['choices'];
      if (choicesRaw is List) {
        for (var item in choicesRaw) {
          final String s = item.toString();
          if (s.contains('|')) {
            choices.addAll(s.split('|').map((e) => e.trim()));
          } else {
            choices.add(s.trim());
          }
        }
      }

      if (choices.length < 2) {
        choices.add('Choix B');
      }
      
      final answerRaw = json['answerIndex'] ?? json['answer'] ?? 0;
      final answerIndex = int.tryParse(answerRaw.toString()) ?? 0;

      // Extract parcours list from JSON
      final List<String> parcoursList = [];
      final parcoursRaw = json['parcours'];
      if (parcoursRaw is List) {
        for (var p in parcoursRaw) {
          parcoursList.add(p.toString().toUpperCase());
        }
      } else if (parcoursRaw is String) {
        parcoursList.add(parcoursRaw.toUpperCase());
      }
      
      return QuizQuestion(
        id: id,
        question: question,
        choices: choices,
        answerIndex: answerIndex.clamp(0, choices.length - 1),
        explanation: (json['explanation']?.toString() ?? 'Ceci est une question officielle de certification.'),
        theme: (json['theme']?.toString() ?? 'général'),
        level: (json['level']?.toString() ?? 'Moyen'),
        parcours: parcoursList.isEmpty ? ['NAT'] : parcoursList,
      );
    } catch (e) {
      return QuizQuestion(
        id: 'err',
        question: 'Erreur de chargement',
        choices: ['-', '-', '-', '-'],
        answerIndex: 0,
        explanation: 'Format invalide.',
        theme: 'erreur',
        level: 'N/A',
        parcours: ['NAT'],
      );
    }
  }

  QuizQuestion getShuffledCopy() {
    if (choices.isEmpty) return this;
    final List<int> indices = List.generate(choices.length, (i) => i);
    indices.shuffle();
    final List<String> shuffledChoices = indices.map((i) => choices[i]).toList();
    final int newAnswerIndex = indices.indexOf(answerIndex);

    return QuizQuestion(
      id: id,
      question: question,
      choices: shuffledChoices,
      answerIndex: newAnswerIndex != -1 ? newAnswerIndex : 0,
      explanation: explanation,
      theme: theme,
      level: level,
      parcours: parcours,
    );
  }
}
