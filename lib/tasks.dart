import 'package:flutter/material.dart';
import 'utils.dart';

/**
 * BIG NOTICE:
 * THIS PAGE IS ULTIMATELY UNUSED,
 * AND WAS SCRAPPED FOR TIME.
 * DETAILS CAN STILL BE FOUND IN THE TUTORIAL
 */

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcade Arena',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),
      home: const MyTasksPage(title: 'Arcade Arena'),
    );
  }
}

class MyTasksPage extends StatefulWidget {
  const MyTasksPage({super.key, required this.title});

  final String title;

  @override
  State<MyTasksPage> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  final Pages currentPage = Pages.tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, currentPage),
      body: const Center(
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This page will have a list of objectives for you to complete!',
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNav(context, currentPage),
    );
  }
}
