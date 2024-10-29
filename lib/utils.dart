import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'global_data.dart';

// Enum for the different pages
enum Pages { layout, store, tasks, config, about }

// List of icons for those pages
const List<IconData> pageIcons = [
  Icons.videogame_asset,
  Icons.shopping_cart,
  Icons.assignment,
  Icons.settings,
  Icons.live_help
];

// ...endpoints for those pages
const List<List<String>> pageTitlesEndpoints = [
  ["Your Arcade", "/"],
  ["Store", "/store"],
  ["Tasks", "/tasks"],
  ["Config", "/config"],
  ["About", "/about"]
];

/// Builds the app bar for the given page
/// 
/// @author Colby Heaton
/// @version 1.0.0
/// @param context - current build context, may use later for theme styling
/// @param cur - enum representing the current page
/// @return appBar - new app bar widget
PreferredSizeWidget? buildAppBar( BuildContext context, Pages cur ) {
  
  PreferredSizeWidget appBar = AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    elevation: 5,
    shadowColor: Colors.black,
    title: Text(
      pageTitlesEndpoints[cur.index][0],
      style: Theme.of(context).textTheme.displayLarge  
    ),
    leading: Icon(
          pageIcons[cur.index],
          size: 40,
      ),
    actions: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: ValueListenableBuilder(
          valueListenable: money,
          builder: (context, value, child) => 
            Text(
              '\$$value',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.displayMedium,
            ),
        )
        
      )
    ],
  );

  if (cur == Pages.store) {
    // money display

  }

  return appBar;
}

/// Builds the bottom nav bar for the given page
/// 
/// @author Colby Heaton
/// @version 1.0.0
/// @param context - current build context, may use later for theme styling
/// @param cur - enum representing the current page
/// @return bottomNav - new bottom nav widget
Widget? buildBottomNav( BuildContext context, Pages cur ) {
  List<Widget> buttons = [];

  // Create icon buttons and push onto list
  for (int i = 0; i < 5; ++i) {
    if (i == Pages.tasks.index) {
      continue;
    }
    
    Color buttColor = const Color.fromARGB(255, 85, 85, 85);

    // current page icon is highlighted
    if (cur.index == i) {
      buttColor = Theme.of(context).colorScheme.primary;
    }
    
    // creating individual buttons,
    // pushing onto button arr
    buttons.add(IconButton(
        onPressed: () => {
          context.go(pageTitlesEndpoints[i][1])
        },
        color: buttColor,
        iconSize: 32,
        icon: Icon(
          pageIcons[i],
        )
      )
    );
  }
  
  Widget bottomNav = BottomAppBar(
    elevation: 5,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons,
    ),
  );

  return bottomNav;
}

/// Generates the theme used throughout the application
/// 
/// @author Colby Heaton
/// @version 1.0.0
/// @return themeData - new theme data
ThemeData? buildThemeData( ) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: appColor),
    useMaterial3: true,
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 37,
        fontWeight: FontWeight.bold,
        fontFamily: 'Pixelify'
      ),
      displayMedium: const TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.bold,
        fontFamily: 'Pixelify'
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        fontFamily: 'Pixelify',
        color: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 49, 48, 89)).onPrimary
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 49, 48, 89)).onPrimary
      ),
      bodySmall: const TextStyle(
        fontSize: 15,
      ),
    ),
  );
}