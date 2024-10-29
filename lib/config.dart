import 'global_data.dart';
import 'game.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcade Arena',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),
      home: const MyConfigPage(title: 'Arcade Arena'),
    );
  }
}

class MyConfigPage extends StatefulWidget {
  const MyConfigPage({super.key, required this.title});

  final String title;

  @override
  State<MyConfigPage> createState() => _MyConfigPageState();
}

class _MyConfigPageState extends State<MyConfigPage> {
  final Pages currentPage = Pages.config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, currentPage),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Spacer(),
              DropdownMenu( // Menu for selecting theme color
                  width: 300,
                  label: Text("App Color",
                      style: Theme.of(context).textTheme.displayMedium),
                  onSelected: (value) => setState(() {
                        // update global apptheme color
                        appColor = value!;
                      }),
                  initialSelection: appColor,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                        value: Color.fromARGB(255, 49, 48, 89),
                        label: "Indigo"),
                    DropdownMenuEntry(
                        value: Color.fromARGB(255, 216, 96, 170),
                        label: "Pink"),
                    DropdownMenuEntry(
                        value: Color.fromARGB(255, 112, 69, 59),
                        label: "Hazel"),
                    DropdownMenuEntry(
                        value: Color.fromARGB(255, 73, 73, 73), label: "Cyan"),
                  ]),
                  Text(
                    "Change the page for it to take effect!",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            title: Text(
                              "WARNING!",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            content: Text(
                              "Starting over is an undo-able action, and you'll be brought back to square one.\nAre you sure you want to restart?",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Back")),
                              ElevatedButton(
                                  onPressed: () {
                                    //reset everything and save
                                    for (int i = 0; i < 8; ++i) {
                                      for (int j = 0; j < 8; ++j) {
                                        layout[i][j]?.clear();
                                      }
                                    }
                                    reset();
                                    savePreferences();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Erase Data"))
                            ],
                          );
                        });
                  },
                  child: Text(
                    "Reset Data",
                    style: Theme.of(context).textTheme.displayMedium,
                  )),
                  Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNav(context, currentPage),
    );
  }
}
