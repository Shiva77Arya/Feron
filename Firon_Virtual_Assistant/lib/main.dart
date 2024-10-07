import 'package:firon_virtual_assistant/Screens/home_screen.dart';
import 'package:firon_virtual_assistant/pallete.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firon Virtual Assistant',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme : const  AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        )
      ),
      home: HomeScreen(),
    );
  }
}

