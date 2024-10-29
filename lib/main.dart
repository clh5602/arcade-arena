import 'package:flutter/material.dart';
import 'router.dart';

void main() {
  runApp(const StartPage());
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  // This widget is the root of your application.
  // Uses the goRouter for page nav
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: getRouter(),
    );
  }
}