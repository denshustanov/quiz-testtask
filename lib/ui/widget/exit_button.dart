import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.close,
        color: Colors.grey,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
