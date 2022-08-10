import 'package:flutter/material.dart';
import 'package:quiz_testtask/ui/page/question_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final categories = <String>['Linux', 'DevOps', 'BASH'];
  String _selectedCategory = 'Linux';

  final difficulties = <String>['easy', 'medium', 'hard'];
  String _selectedDifficulty = 'easy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select quiz',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Category'),
              items: categories
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
              value: _selectedCategory,
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: difficulties
                    .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ))
                    .toList(),
                value: _selectedDifficulty,
                onChanged: (String? value) {
                  setState(() {
                    _selectedDifficulty = value!;
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuestionPage(
                          _selectedCategory, _selectedDifficulty)));
                },
                child: const Text('Start quiz')),
          )
        ],
      ),
    );
  }
}
