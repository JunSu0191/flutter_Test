import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class ShapeModel with ChangeNotifier {
  int _score = 0;
  int get score => _score;

  List<Shape> _shapes = [];
  List<Shape> get shapes => _shapes;

  void addScore(int points) {
    _score += points;
    notifyListeners();
  }

  void initializeShapes() {
    final random = Random();
    List<Color> colors = List<Color>.from(Colors.primaries)..shuffle();
    _shapes = [];

    for (int i = 0; i < 8; i++) {
      double size = 100;

      _shapes.add(Shape(size, colors[i]));
      _shapes.add(Shape(size, colors[i]));
    }

    _shapes.shuffle();
    notifyListeners();
  }
}

class Shape {
  double size;
  Color color;
  bool isVisible;

  Shape(this.size, this.color, {this.isVisible = false});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShapeModel()..initializeShapes(),
      child: MaterialApp(
        title: '카드 맞추기',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Shape? firstSelectedShape;
  Shape? secondSelectedShape;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matching Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score: ${Provider.of<ShapeModel>(context).score}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<ShapeModel>(context, listen: false).initializeShapes();
              },
              child: Text('Restart Game'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<ShapeModel>(
                builder: (context, shapeModel, child) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: shapeModel.shapes.length,
                    itemBuilder: (context, index) {
                      Shape shape = shapeModel.shapes[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (firstSelectedShape == null) {
                              firstSelectedShape = shape;
                              firstSelectedShape!.isVisible = true;
                            } else if (secondSelectedShape == null) {
                              secondSelectedShape = shape;
                              secondSelectedShape!.isVisible = true;

                              if (firstSelectedShape!.color == secondSelectedShape!.color) {
                                Provider.of<ShapeModel>(context, listen: false).addScore(1);
                                firstSelectedShape = null;
                                secondSelectedShape = null;
                              } else {
                                Future.delayed(Duration(seconds: 1), () {
                                  setState(() {
                                    firstSelectedShape!.isVisible = false;
                                    secondSelectedShape!.isVisible = false;
                                    firstSelectedShape = null;
                                    secondSelectedShape = null;
                                  });
                                });
                              }
                            }
                          });
                        },
                        child: Container(
                          width: shape.size,
                          height: shape.size,
                          color: shape.isVisible ? shape.color : Colors.grey,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
