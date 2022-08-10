import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_testtask/ui/widget/question_widget.dart';
import '../../model/quiz/quiz.dart';
import '../../quiz_api.dart';
import '../widget/exit_button.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage(this.category, this.difficulty, {Key? key})
      : super(key: key);
  final String category;
  final String difficulty;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late final _quizApi = Provider.of<QuizApi>(context);
  late final Future<Quiz> _futureQuiz = _getQuiz();
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quiz>(
        future: _futureQuiz,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: const ExitButton(),
                title:
                    const Text('Error', style: TextStyle(color: Colors.black)),
              ),
              body: const Center(
                child: Text('Loading error'),
              ),
            );
          } else if (snapshot.hasData) {
            return QuestionWidget(snapshot.data!);
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: const ExitButton(),
              title: const Text('Loading quiz...',
                  style: TextStyle(color: Colors.black)),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Future<Quiz> _getQuiz() async {
    return await _quizApi.getQuestions(widget.category, widget.difficulty);
  }
}
