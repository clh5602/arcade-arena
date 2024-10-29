import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global_data.dart';

const int tileSize = 32; // Pixel Dimensions
int tappedRow = -1; // Default when nothing selected
int tappedCol = -1;
bool attemptedLoad = false; // Load shared preferences once
List<List<Item?>> layout = []; // 2D array of ITEMs, for grid
List<InventoryButton> inventoryButts = []; // List of buttons corresponding to your inventory

/// Saves money and current day to sharedPreferences
/// 
/// @author Colby Heaton
void savePreferences() async {
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // save day number, and total money
  await prefs.setInt('day', day);
  await prefs.setInt('money', money.value);
}

/// Tries to retrieve money and day from shared preferences
/// 
/// @author Colby Heaton
Future<void> loadPreferences() async {
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // get day number, and total money
  int? test;
  test = prefs.getInt('day');
  if (test != null) {
    // days was found
    day = test;
  }

  test = prefs.getInt('money');
  if (test != null) {
    // money was found
    money = ValueNotifier(test);
  }
}

/// Class for the Floor tiles, which can have an item placed on them
/// 
/// @author Colby Heaton
class Item extends PositionComponent with TapCallbacks {
  int row = 0; // my row index
  int col = 0; // my col index
  bool visible = false; // visible == has an item on it
  int facing = 0; // 0 is down, 1 is left, 2 is up, 3 is right
  ItemIds id = ItemIds.mach1; // default
  static final Sprite tile = Sprite(Flame.images.fromCache('sprites/tile.png'));
  static final Sprite active =
      Sprite(Flame.images.fromCache('sprites/tile_active.png'));
  Sprite? down; // sprites for each direction
  Sprite? left;
  Sprite? up;
  Sprite? right;

  /// Selects this tile when tapped
  /// 
  /// @author - Colby Heaton
  /// @param - event, reference to the tap event
  @override
  void onTapDown(TapDownEvent event) {
    // Tapped on me
    tappedCol = col;
    tappedRow = row;
  }

  /// Points this instance to a specific coordinate index
  /// 
  /// @author - Colby Heaton
  /// @param _row - the row that this tile is in
  /// @param _col - the col that this tile is in
  Item(int _row, int _col)
      : super(
            position: Vector2((_col + 2.5) * tileSize, (_row + 2.0) * tileSize),
            size: Vector2(1.0 * tileSize, 1.0 * tileSize),
            anchor: Anchor.topCenter) {
    row = _row;
    col = _col;
  }

  /// Rotates this object
  /// 
  /// @author - Colby Heaton
  void rotateClockwise() {
    if (facing == 3) flipHorizontally();
    facing += 1;
    facing %= 4;
    if (facing == 3) flipHorizontally();
  }

  /// Rotates the object
  /// 
  /// @author Colby Heaton
  void rotateCounterClockwise() {
    if (facing == 3) flipHorizontally();
    facing += 3;
    facing %= 4;
    if (facing == 3) flipHorizontally();
  }

  /// Removes the item placed on this tile,
  /// if one exists. Also returns it to the inventory.
  /// 
  /// @author Colby Heaton
  void clear() {
    if (visible) {
      visible = false;
      inventory.update(id, (value) => value + 1);
      if (facing == 3) {
        flipHorizontally();
      }
      facing = 0;
    }
  }

  /// Get the popularity value associated with this item
  /// 
  /// @author - Colby Heaton
  int getPopularity() {
    if (!visible) {
      return 0;
    }
    return database[id]?['popularity'];
  }

  /// Get the profitability value associated with this item
  /// 
  /// @author - Colby Heaton
  int getProfitability() {
    if (!visible) {
      return 0;
    }
    return database[id]?['profitability'];
  }

  /// Places an item on this tile,
  /// fetches the necessary sprites from the cache
  /// 
  /// @author Colby Heaton
  /// @param newId - ItemIds enum related to the placed item
  void updateContents(ItemIds newId) {
    id = newId;

    switch (newId) {
      case ItemIds.mach1:
        up = Sprite(Flame.images.fromCache('sprites/mach1_b.png'));
        down = Sprite(Flame.images.fromCache('sprites/mach1_f.png'));
        left = Sprite(Flame.images.fromCache('sprites/mach1_s.png'));
        right = Sprite(Flame.images.fromCache('sprites/mach1_s.png'));
        break;
      case ItemIds.mach2:
        up = Sprite(Flame.images.fromCache('sprites/mach2_b.png'));
        down = Sprite(Flame.images.fromCache('sprites/mach2_f.png'));
        left = Sprite(Flame.images.fromCache('sprites/mach2_s.png'));
        right = Sprite(Flame.images.fromCache('sprites/mach2_s.png'));
        break;
      case ItemIds.ad1:
        up = Sprite(Flame.images.fromCache('sprites/ad1_b.png'));
        down = Sprite(Flame.images.fromCache('sprites/ad1_f.png'));
        left = Sprite(Flame.images.fromCache('sprites/ad1_s.png'));
        right = Sprite(Flame.images.fromCache('sprites/ad1_s.png'));
        break;
      case ItemIds.vend1:
        up = Sprite(Flame.images.fromCache('sprites/vend1_b.png'));
        down = Sprite(Flame.images.fromCache('sprites/vend1_f.png'));
        left = Sprite(Flame.images.fromCache('sprites/vend1_s.png'));
        right = Sprite(Flame.images.fromCache('sprites/vend1_s.png'));
        break;
      case ItemIds.plant:
        up = Sprite(Flame.images.fromCache('sprites/plant.png'));
        down = Sprite(Flame.images.fromCache('sprites/plant.png'));
        left = Sprite(Flame.images.fromCache('sprites/plant.png'));
        right = Sprite(Flame.images.fromCache('sprites/plant.png'));
        break;
      case ItemIds.claw1:
        up = Sprite(Flame.images.fromCache('sprites/claw1.png'));
        down = Sprite(Flame.images.fromCache('sprites/claw1.png'));
        left = Sprite(Flame.images.fromCache('sprites/claw1.png'));
        right = Sprite(Flame.images.fromCache('sprites/claw1.png'));
        break;
    }

    visible = true;
  }

  /// Draws the tile, and special if it's currently selected.
  /// Then draws the item on top, with the correct direction
  /// 
  /// @author Colby Heaton
  @override
  void render(Canvas canvas) {
    if (tappedCol == col && tappedRow == row) {
      active.render(canvas);
    } else {
      tile.render(canvas);
    }

    Vector2 machPos = Vector2(0, -1.0 * tileSize);

    if (visible) {
      switch (facing) {
        case 0:
          down?.render(canvas, position: machPos);
          break;
        case 1:
          left?.render(canvas, position: machPos);
          break;
        case 2:
          up?.render(canvas, position: machPos);
          break;
        case 3:
          right?.render(canvas, position: machPos);
          break;
      }
    }
  }
}

/// Forces all InventoryButtons to update their text
/// 
/// @author Colby Heaton
void updateCounts() {
  for (int i = 0; i < inventoryButts.length; ++i) {
    inventoryButts[i].updateCount();
  }
}

/// Button for placing an item from your inventory onto the grid
/// Also displays the number of this item that you have in reserve.
/// 
/// @author Colby Heaton
class InventoryButton extends PositionComponent with TapCallbacks {
  late ItemIds id;
  late Sprite me;
  late TextComponent myText;

  /// Creates this instance and its text component
  /// 
  /// @author Colby Heaton
  /// @param item - ItemId for this item
  /// @param pos - places it in the world
  /// @param _world - world reference to add the textComponent
  InventoryButton(ItemIds item, Vector2 pos, World _world)
      : super(position: pos, size: Vector2(1.0 * tileSize, 2.0 * tileSize)) {
    id = item;

    switch (id) {
      case ItemIds.ad1:
        me = Sprite(Flame.images.fromCache('sprites/ad1_f.png'));
        break;
      case ItemIds.claw1:
        me = Sprite(Flame.images.fromCache('sprites/claw1.png'));
        break;
      case ItemIds.mach1:
        me = Sprite(Flame.images.fromCache('sprites/mach1_f.png'));
        break;
      case ItemIds.mach2:
        me = Sprite(Flame.images.fromCache('sprites/mach2_f.png'));
        break;
      case ItemIds.plant:
        me = Sprite(Flame.images.fromCache('sprites/plant.png'));
        break;
      case ItemIds.vend1:
        me = Sprite(Flame.images.fromCache('sprites/vend1_f.png'));
        break;
    }
    myText = TextComponent(
        text: inventory[id].toString(),
        position: pos + Vector2(tileSize * 0.5, tileSize * 3.0),
        anchor: Anchor.bottomCenter);
    _world.add(myText);
  }

  /// Updates the value displayed by this button's text component
  /// 
  /// @author Colby Heaton
  void updateCount() {
    myText.text = inventory[id].toString();
  }

  /// If a tile is selected an there are more than 0 in the inventory,
  /// place it.
  @override
  void onTapDown(TapDownEvent event) {
    // Tapped on me
    if (inventory[id]! > 0 && tappedRow != -1 && tappedCol != -1) {
      // Remove old machine
      layout[tappedRow][tappedCol]?.clear();

      inventory.update(id, (value) => value - 1);

      // Add new one
      layout[tappedRow][tappedCol]?.updateContents(id);
    }
    updateCounts();
  }

  @override
  void render(Canvas canvas) {
    me.render(canvas, position: Vector2(0, 0));
  }
}

/// Button that rotates items clockwise or counterclockwise
class RotateButton extends PositionComponent with TapCallbacks {
  late bool clockwise;
  static Sprite me = Sprite(Flame.images.fromCache('sprites/rotate.png'));

  /// _clockwise determines the rotation direction
  RotateButton(bool _clockwise, Vector2 pos)
      : super(position: pos, size: Vector2(1.5 * tileSize, 1.5 * tileSize)) {
    clockwise = _clockwise;
    if (clockwise) flipHorizontally();
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Tapped on me
    if (tappedRow != -1 && tappedCol != -1) {
      // Rotate the thing at this position
      if (clockwise) {
        layout[tappedRow][tappedCol]?.rotateClockwise();
      } else {
        layout[tappedRow][tappedCol]?.rotateCounterClockwise();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    me.render(canvas);
  }
}

/// Button that removes items from the grid
class RemoveButton extends PositionComponent with TapCallbacks {
  static Sprite me = Sprite(Flame.images.fromCache('sprites/remove.png'));

  RemoveButton(Vector2 pos)
      : super(position: pos, size: Vector2(1.5 * tileSize, 1.5 * tileSize));

  @override
  void onTapDown(TapDownEvent event) {
    // Tapped on me
    if (tappedRow != -1 && tappedCol != -1) {
      // Remove the thing at this position
      layout[tappedRow][tappedCol]?.clear();
      updateCounts();
    }
  }

  @override
  void render(Canvas canvas) {
    me.render(canvas);
  }
}

/// Button that opens your business for the day,
/// progresses the game
class OpenButton extends PositionComponent with TapCallbacks {
  late BuildContext context;
  static Sprite me = Sprite(Flame.images.fromCache('sprites/open.png'));

  OpenButton(BuildContext _context, Vector2 pos)
      : super(position: pos, size: Vector2(2.0 * tileSize, 1.5 * tileSize)) {
    context = _context;
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Tapped on me

    // Calculate total popularity and revenue
    int totalPop = 0;
    int totalProfit = 0;

    // Loop thru layout
    for (int i = 0; i < layout.length; ++i) {
      for (int j = 0; j < layout[i].length; ++j) {
        totalPop += layout[i][j]!.getPopularity();
        totalProfit += layout[i][j]!.getProfitability();
      }
    }

    // Get cashola
    money.value += totalPop * totalProfit;
    String? message;
    
    // rent day?
    if (day % 7 == 0) {
      money.value -= (day / 7).ceil() * 215;
      if (money.value < 0) {
        // bankrupt!
        message = "You had $totalPop visitors,\nand earned \$${totalPop * totalProfit} in revenue!\n\nCouldn't afford rent! Game Over!";
      } else {
        // could afford
        message = "You had $totalPop visitors,\nand earned \$${totalPop * totalProfit} in revenue!\n\nPaid \$${(day / 7).ceil() * 215} in rent!";
      }
    } else {
      message = "You had $totalPop visitors,\nand earned \$${totalPop * totalProfit} in revenue!\n\nRent of \$${(day / 7).ceil() * 215} is due in ${7 - (day % 7)} day(s)...";
    }

    int prevDay = day;

    // Show results
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            title: Text(
              "Day $prevDay Summary",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            content: Text(
              message!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        });
    
    // Game over
    if (money.value < 0) {
      //reset everything and save
      for (int i = 0; i < 8; ++i) {
        for (int j = 0; j < 8; ++j) {
          layout[i][j]?.clear();
        }
      }
      reset();
      updateCounts();
      savePreferences();
    } else {
      day++;
    }
    savePreferences();
  }

  @override
  void render(Canvas canvas) {
    me.render(canvas);
  }
}

class ArcadeArena extends FlameGame {
  BuildContext? context;

  /// Capture context for showing dialogs
  ArcadeArena(BuildContext _context) : super() {
    context = _context;
  }

  @override
  Future<void> onLoad() async {
    // Load preferences
    if (!attemptedLoad) {
      attemptedLoad = true;
      await loadPreferences();
    }

    // Lots of very lightweight images
    await Flame.images.load('sprites/ad1_b.png');
    await Flame.images.load('sprites/ad1_f.png');
    await Flame.images.load('sprites/ad1_s.png');
    await Flame.images.load('sprites/claw1.png');
    await Flame.images.load('sprites/mach1_b.png');
    await Flame.images.load('sprites/mach1_f.png');
    await Flame.images.load('sprites/mach1_s.png');
    await Flame.images.load('sprites/mach2_b.png');
    await Flame.images.load('sprites/mach2_f.png');
    await Flame.images.load('sprites/mach2_s.png');
    await Flame.images.load('sprites/vend1_b.png');
    await Flame.images.load('sprites/vend1_f.png');
    await Flame.images.load('sprites/vend1_s.png');
    await Flame.images.load('sprites/plant.png');
    await Flame.images.load('sprites/tile.png');
    await Flame.images.load('sprites/tile_active.png');
    await Flame.images.load('sprites/rotate.png');
    await Flame.images.load('sprites/remove.png');
    await Flame.images.load('sprites/open.png');

    tappedRow = -1;
    tappedCol = -1;

    // Backdrop
    ParallaxComponent background = await loadParallaxComponent([
      ParallaxImageData('sprites/backdrop_1.png'),
      ParallaxImageData('sprites/backdrop_2.png')
    ],
        baseVelocity: Vector2(10, 10),
        velocityMultiplierDelta: Vector2(2, 1.8),
        repeat: ImageRepeat.repeat,
        fill: LayerFill.none);
    world.add(background);

    // Create a base arcade, 8x8
    if (layout.isEmpty) {
      for (int i = 0; i < 8; ++i) {
        List<Item> row = [];
        for (int j = 0; j < 8; ++j) {
          row.add(Item(i, j));
          world.add(row[j]);
        }
        layout.add(row);
      }
    } else {
      // layout already exists
      for (int i = 0; i < 8; ++i) {
        for (int j = 0; j < 8; ++j) {
          world.add(layout[i][j] as Component);
        }
      }
    }

    // Create inventory buttons
    for (int i = 0; i < ItemIds.values.length; ++i) {
      inventoryButts.add(InventoryButton(ItemIds.values[i],
          Vector2((tileSize * 1.4) * (i + 1.5), tileSize * 12.0), world));
      world.add(inventoryButts[i]);
    }

    // Create rotate buttons
    world.add(RotateButton(false, Vector2(tileSize * 2, tileSize * 10.25)));
    world.add(RemoveButton(Vector2(tileSize * 3.75, tileSize * 10.25)));
    world.add(RotateButton(true, Vector2(tileSize * 7, tileSize * 10.25)));
    world.add(OpenButton(context!, Vector2(tileSize * 8, tileSize * 10.25)));

    // Setup camera stuff
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.position = Vector2(1.4 * tileSize, 0.7 * tileSize);
    camera.viewfinder.zoom = 1.4;
  }
}
