import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_app/food_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyFoodScreen(),
    );
  }
}

class MyFoodScreen extends StatefulWidget {
  const MyFoodScreen({super.key});

  @override
  State<MyFoodScreen> createState() => _MyFoodScreenState();
}

class _MyFoodScreenState extends State<MyFoodScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  List<FoodModel> _foodlist = foodList;

  double get _currentOffset {
    bool inited = _pageController.hasClients &&
        _pageController.position.hasContentDimensions;
    return inited ? _pageController.page! : _pageController.initialPage * 1.0;
  }

  int get _currentIndex => _currentOffset.round() % _foodlist.length;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _foodlist.length * 9999,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          return _buildScreen();
        },
      ),
    );
  }

  Stack _buildScreen() {
    final Size size = MediaQuery.of(context).size;
    final FoodModel _currentFood = _foodlist[_currentIndex];
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -size.width * 0.6,
          child: BgImage(
            currentIndex: _currentIndex,
            food: _currentFood,
            pageOffset: _currentOffset,
          ),
        ),
        SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _currentFood.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "\$${_currentFood.price}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.pink.shade800,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: size.height * 0.1),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.3,
                    vertical: size.height * 0.03,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {},
              child: const Text(
                "Add to cart",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Swipe to see Recipes",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )),
        Center(
          child: SizedBox(
            height: size.width,
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                double _value = 0.0;
                double vp = 1;
                double scale = max(vp, (_currentOffset - index).abs());

                if (_pageController.position.haveDimensions) {
                  _value = index.toDouble() - (_pageController.page ?? 0);
                  _value = (_value * 0.7).clamp(-1, 1);
                }
                return Transform.rotate(
                    angle: pi * _value,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 200 - scale * 5),
                      child: FittedBox(
                        child: Image.asset(
                          _foodlist[index % _foodlist.length].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ));
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BgImage extends StatefulWidget {
  const BgImage(
      {super.key,
      required this.currentIndex,
      required this.food,
      required this.pageOffset});

  final int currentIndex;
  final FoodModel food;
  final double pageOffset;

  @override
  State<BgImage> createState() => _BgImageState();
}

class _BgImageState extends State<BgImage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double _value = 0.0;
    _value = (widget.pageOffset - widget.currentIndex).abs();
    return Opacity(
      opacity: 0.2,
      child: Transform.rotate(
        angle: pi * _value + pi / 180,
        child: SizedBox(
          width: size.width * 1.5,
          height: size.width * 1.5,
          child: Image.asset(
            widget.food.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
