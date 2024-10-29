import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'global_data.dart';
import 'utils.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcade Arena',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),
      home: const MyStorePage(title: 'Arcade Arena'),
    );
  }
}

class MyStorePage extends StatefulWidget {
  const MyStorePage({super.key, required this.title});

  final String title;

  @override
  State<MyStorePage> createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  final Pages currentPage = Pages.store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, currentPage),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), // Removes scrollbars
          child: ListView.separated( // List of items
            itemCount: ItemIds.values.length + 2, // +2 for space above and below
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20); // Spacers
            },
            itemBuilder: (context, index) {
              if (index == 0 || index == ItemIds.values.length + 1) {
                return const SizedBox.shrink(); // More Spacers
              }
              --index;
              return Container( // Single Item
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)
                ),
                height: 120,
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.onPrimaryContainer,
                              Theme.of(context).colorScheme.onSecondaryContainer
                            ]
                        )
                      ),
                      // Thumbnail
                      child: Image(image: AssetImage('assets/images/sprites/${database[ItemIds.values[index]]?["f_sprite"]}')),
                    ),
                    Container(
                      // Stats
                      padding: const EdgeInsets.only(left: 10),
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            database[ItemIds.values[index]]?['name'],
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            'Popularity: ${database[ItemIds.values[index]]?['popularity']}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Profit: ${database[ItemIds.values[index]]?['profitability']}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'In Storage: ${inventory[ItemIds.values[index]]}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton( // Purchase button / costs
                      onPressed: () {
                        Map<String, dynamic>? item = database[ItemIds.values[index]];
                        int price = item?['price'];
                        if (money.value >= price) {
                          // time to buy
                          setState(() {
                            money.value -= price;
                            inventory.update(
                              ItemIds.values[index],
                              (val) => val + 1
                            );
                            
                          });
                        } else {
                          // Error handle
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Not enough money!'),
                              showCloseIcon: true,
                            ),
                          );
                        }
                      },
                      child: Text(
                        '\$${database[ItemIds.values[index]]?['price']}',
                      )
                    )
                  ],
                )
              );
            }
          ),
        )
      ),
      bottomNavigationBar: buildBottomNav(context, currentPage),
    );
  }
}
