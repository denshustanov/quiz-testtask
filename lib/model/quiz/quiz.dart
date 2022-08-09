import 'package:quiz_testtask/model/quiz/question.dart';

class Quiz{
  final List<Question> questions;
  final String category;
  final String difficulty;

  Quiz(this.questions, this.category, this.difficulty);
}