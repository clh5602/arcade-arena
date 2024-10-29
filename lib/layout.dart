import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game.dart';
import 'utils.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcade Arena',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),
      home: const MyLayoutPage(title: 'Arcade Arena'),
    );
  }
}

class MyLayoutPage extends StatefulWidget {
  const MyLayoutPage({super.key, required this.title});

  final String title;

  @override
  State<MyLayoutPage> createState() => _MyLayoutPageState();
}

/// This hosts the game
class _MyLayoutPageState extends State<MyLayoutPage> {
  final Pages currentPage = Pages.layout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, currentPage),
      body: GameWidget(game: ArcadeArena(context)),
      bottomNavigationBar: buildBottomNav(context, currentPage),
    );
  }
}
