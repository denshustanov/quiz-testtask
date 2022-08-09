import 'dart:convert';
import 'package:http/http.dart';
import 'package:quiz_testtask/model/quiz/quiz.dart';
import 'model/quiz/question.dart';

class QuizApi {
  static const String _quizApiQuestionsUrl =
      'https://quizapi.io/api/v1/questions/';
  static const String _apiKey = 'YuTbwAwiAa6Hxf08TrCb4GcOf4odXfEl3tcJPBrG';

  Future<Quiz> getQuestions(String category, String difficulty) async {
    final querryParams = {
      'category': category,
      'difficulty': difficulty,
      'limit': '10',
    };

    final response = await get(
        Uri.parse(_quizApiQuestionsUrl).replace(queryParameters: querryParams),
        headers: {'X-Api-Key': _apiKey});
    print(response.statusCode);
    final json = jsonDecode(response.body);
    print(json);
    final List<Question> questions =
        List.from(json.map((e) => Question.fromMap(e)));
    return Quiz(questions, category, difficulty);
  }
}
