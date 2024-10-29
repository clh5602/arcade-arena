import 'dart:ui';

import 'package:flutter/foundation.dart';

// ID for every item
enum ItemIds { mach1, mach2, vend1, ad1, claw1, plant}

// Default theme color
Color appColor = Color.fromARGB(255, 49, 48, 89);

// Money value and Day
ValueNotifier<int> money = ValueNotifier<int>(300);
int day = 1;


// This Map defines every item in the game.
final Map<ItemIds, Map<String, dynamic>> database = {
  ItemIds.mach1: {
    "id": ItemIds.mach1,
    "name": "Astro Destroyer",
    "f_sprite": "mach1_f.png",
    "s_sprite": "mach1_s.png",
    "b_sprite": "mach1_b.png",
    "price": 40,
    "popularity": 4,
    "profitability": 2,
  },
  ItemIds.mach2: {
    "id": ItemIds.mach2,
    "name": "Boxing Legend",
    "f_sprite": "mach2_f.png",
    "s_sprite": "mach2_s.png",
    "b_sprite": "mach2_b.png",
    "price": 70,
    "popularity": 3,
    "profitability": 5,
  },
  ItemIds.vend1: {
    "id": ItemIds.vend1,
    "name": "Vending Machine",
    "f_sprite": "vend1_f.png",
    "s_sprite": "vend1_s.png",
    "b_sprite": "vend1_b.png",
    "price": 110,
    "popularity": 1,
    "profitability": 8,
  },
  ItemIds.ad1: {
    "id": ItemIds.ad1,
    "name": "Cardboard Cutout",
    "f_sprite": "ad1_f.png",
    "s_sprite": "ad1_s.png",
    "b_sprite": "ad1_b.png",
    "price": 15,
    "popularity": 3,
    "profitability": 0,
  },
  ItemIds.claw1: {
    "id": ItemIds.claw1,
    "name": "Claw Machine",
    "f_sprite": "claw1.png",
    "s_sprite": "claw1.png",
    "b_sprite": "claw1.png",
    "price": 160,
    "popularity": 6,
    "profitability": 5,
  },
  ItemIds.plant: {
    "id": ItemIds.plant,
    "name": "Charlie",
    "f_sprite": "plant.png",
    "s_sprite": "plant.png",
    "b_sprite": "plant.png",
    "price": 1000,
    "popularity": 1,
    "profitability": 0,
  },
};

// Inventory of what the player has in reserve
Map<ItemIds, int> inventory = {
  ItemIds.mach1: 0,
  ItemIds.mach2: 0,
  ItemIds.vend1: 0,
  ItemIds.ad1: 0,
  ItemIds.claw1: 0,
  ItemIds.plant: 0,
};

// Helper when resetting game
void reset() {
  money.value = 300;
  day = 1;
  inventory.updateAll((key, value) => 0);
}