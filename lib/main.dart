import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_testtask/firestore_service.dart';
import 'package:quiz_testtask/quiz_api.dart';
import 'package:quiz_testtask/ui/page/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<QuizApi>(create: (_) => QuizApi()),
        Provider<FirestoreService>(create: (_) => FirestoreService())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MainPage()),
    );
  }
}
