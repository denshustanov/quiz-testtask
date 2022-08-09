import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:quiz_testtask/model/quiz/question.dart';
import 'package:quiz_testtask/ui/page/quiz_results_page.dart';
import 'package:quiz_testtask/ui/widget/exit_button.dart';

import '../../model/quiz/quiz.dart';
import '../../model/quiz/results.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget(this.quiz, {Key? key}) : super(key: key);
  final Quiz quiz;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  List<bool> selectedAnswers = [];
  int _currentQuestion = 0;
  List<List<bool>> quizAnswers = [];
  int correctAnswersCount = 0;

  @override
  void initState() {
    selectedAnswers = List.filled(
        widget.quiz.questions.elementAt(_currentQuestion).answers.length,
        false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: const ExitButton(),
          title: SizedBox(
            height: 30,
            width: 30,
            child: Stack(children: [
              Center(
                child: CircularProgressIndicator(
                  value: (_currentQuestion + 1) / widget.quiz.questions.length,
                  color: Colors.blue,
                  backgroundColor: Colors.grey,
                ),
              ),
              Center(
                  child: Text(
                (_currentQuestion + 1).toString(),
                style: const TextStyle(color: Colors.grey),
              ))
            ]),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.quiz.questions.elementAt(_currentQuestion).question,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.quiz.questions
                      .elementAt(_currentQuestion)
                      .multipleCorrectAnswers
                  ? 'Select multiple answers'
                  : 'Select single answer'),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.quiz.questions
                      .elementAt(_currentQuestion)
                      .answers
                      .length,
                  itemBuilder: (context, index) {
                    String? answer = widget.quiz.questions
                        .elementAt(_currentQuestion)
                        .answers
                        .elementAt(index);
                    if (answer != null) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              answerTapHandler(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.blue),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      answer,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Checkbox(
                                      checkColor: Colors.white,
                                      side: MaterialStateBorderSide.resolveWith(
                                          (states) => const BorderSide(
                                              width: 1.0, color: Colors.white)),
                                      value: selectedAnswers.elementAt(index),
                                      onChanged: (value) {
                                        answerTapHandler(index);
                                      })
                                ],
                              ),
                            ),
                          ));
                    }
                    return const SizedBox.shrink();
                  }),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: nextQuestionHandler, child: const Text('Next')),
            )
          ],
        ));
  }

  answerTapHandler(index) {
    setState(() {
      if (widget.quiz.questions
          .elementAt(_currentQuestion)
          .multipleCorrectAnswers) {
        selectedAnswers[index] = !selectedAnswers[index];
      } else {
        selectedAnswers = List.filled(
            widget.quiz.questions.elementAt(_currentQuestion).answers.length,
            false);
        selectedAnswers[index] = true;
      }
    });
  }

  nextQuestionHandler() async {
    if (selectedAnswers.any((element) => element)) {
      final correct = checkAnswer();
      if (correct) {
        correctAnswersCount += 1;
      }
      await showModalBottomSheet(
          barrierColor: Colors.white.withOpacity(0),
          isDismissible: false,
          isScrollControlled: false,
          enableDrag: false,
          context: context,
          builder: (context) {
            return Container(
              height: 100,
              decoration:
                  BoxDecoration(color: correct ? Colors.green : Colors.red),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      correct ? 'Correct!' : 'Wrong!',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary:
                              correct ? Colors.greenAccent : Colors.redAccent),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            );
          });
      quizAnswers.add(List.from(selectedAnswers));
      if (_currentQuestion >= widget.quiz.questions.length - 1) {
        final results = createResults();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => QuizResultsPage(results)));
      }
      setState(() {
        if (_currentQuestion < widget.quiz.questions.length) {
          _currentQuestion += 1;
        }
        selectedAnswers = List.filled(
            widget.quiz.questions.elementAt(_currentQuestion).answers.length,
            false);
      });
    }
  }

  bool checkAnswer() {
    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] !=
          widget.quiz.questions.elementAt(_currentQuestion).correctAnswers[i]) {
        return false;
      }
    }
    return true;
  }

  Results createResults() {
    return Results(
        widget.quiz.category,
        widget.quiz.difficulty,
        correctAnswersCount,
        widget.quiz.questions.length - correctAnswersCount,
        DateTime.now());
  }
}
