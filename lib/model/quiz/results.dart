class Results {
  String category;
  String difficulty;
  int correctAnswers;
  int wrongAnswers;
  DateTime quizDateTime;

  Results(
    this.category,
    this.difficulty,
    this.correctAnswers,
    this.wrongAnswers,
    this.quizDateTime,
  );

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "difficulty": difficulty,
      "correctAnswers": correctAnswers,
      "wrongAnswers": wrongAnswers,
      "quizDateTime": quizDateTime.toString()
    };
  }
}
