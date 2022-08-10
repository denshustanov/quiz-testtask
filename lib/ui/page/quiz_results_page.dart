import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_testtask/firestore_service.dart';
import 'package:quiz_testtask/ui/widget/loading_dialog.dart';

import '../../model/quiz/results.dart';

class QuizResultsPage extends StatefulWidget {
  const QuizResultsPage(this.results, {Key? key}) : super(key: key);
  final Results results;

  @override
  State<QuizResultsPage> createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> {
  late final firestoreService =
      Provider.of<FirestoreService>(context, listen: false);

  static const TextStyle _greyLabelStyle = TextStyle(
      fontSize: 18, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Quiz results',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: Stack(children: [
                  Center(
                    child: CircularProgressIndicator(
                      value: _quizCorrectAnswersPercentage(),
                      color: Colors.blue,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(_quizCorrectAnswersPercentage() * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                ]),
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          'Category:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            widget.results.category,
                            style: _greyLabelStyle  ,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('Difficulty:',
                            style: TextStyle(fontSize: 18)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(widget.results.difficulty,
                              style:_greyLabelStyle),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('Correct answers:',
                            style: TextStyle(fontSize: 18)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(widget.results.correctAnswers.toString(),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.green)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('Wrong answers:',
                            style: TextStyle(fontSize: 18)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(widget.results.wrongAnswers.toString(),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.red)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: saveResultsHandler,
                child: const Text('Save results'))
          ],
        ),
      ),
    );
  }

  saveResultsHandler() async {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return const LoadingDialog();
        });
    await firestoreService.addResult(widget.results);
    if(mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  double _quizCorrectAnswersPercentage() {
    return widget.results.correctAnswers /
        (widget.results.correctAnswers + widget.results.wrongAnswers);
  }
}
