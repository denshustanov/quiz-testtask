class Question {
  int id;
  String question;
  String? description;
  List<String?> answers;
  List<bool> correctAnswers;
  bool multipleCorrectAnswers;

  Question(this.id, this.question, this.description, this.answers,
      this.correctAnswers, this.multipleCorrectAnswers);

  factory Question.fromMap(Map<String, dynamic> map) {
    List<String?> answers = [];
    List<bool> correctAnswers = [];

    map['answers'].forEach((k, v) => answers.add(v));
    map['correct_answers'].forEach((k, v) => correctAnswers.add(v == "true"));

    return Question(map['id'], map['question'], map['description'], answers,
        correctAnswers, map['multipleCorrectAnswers'] == "true");
  }
}
