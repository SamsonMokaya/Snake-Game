import 'dart:async';
import 'dart:math';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'blank_pixel.dart';
import 'snake_pixel.dart';
import 'food_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // grid dimensions
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  //snake positions
  List<int> snakePos = [
    0,
    1,
    2,
  ];

  //snake direction
  var currentSnakeDirection = snake_direction.RIGHT;

  //Snack positions
  int foodPos = 55;

  //Start game
  void _startGame() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
        eatSnack();
      });
    });
  }

  void eatSnack(){
    while(snakePos.contains(foodPos)){
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  void moveSnake() {
    switch (currentSnakeDirection) {
      case snake_direction.RIGHT:
        {

          //add a head
          if(snakePos.last % rowSize == 9){
             snakePos.add(snakePos.last + 1 - rowSize);
          }else{
             snakePos.add(snakePos.last + 1);
          }

        }

        break;
      case snake_direction.LEFT:
        {
          //add a head
          if(snakePos.last % rowSize == 0){
             snakePos.add(snakePos.last - 1 + rowSize);
          }else{
             snakePos.add(snakePos.last - 1);
          }

        }

        break;
      case snake_direction.UP:
        {
          //add a head
          if(snakePos.last < rowSize){
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          }else{
          snakePos.add(snakePos.last - rowSize);
          }

        }

        break;
      case snake_direction.DOWN:
        {
          //add a head
          if(snakePos.last + rowSize > totalNumberOfSquares){
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          }else{
          snakePos.add(snakePos.last + rowSize);
          }


         
        }

        break;
      default:
    }
    if(snakePos.last == foodPos){
      eatSnack();
    }else{
       snakePos.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && currentSnakeDirection != snake_direction.UP) {
                  currentSnakeDirection = snake_direction.DOWN;
                  print("Move down");
                }
                else if (details.delta.dy < 0 && currentSnakeDirection != snake_direction.DOWN) {
                  currentSnakeDirection = snake_direction.UP;
                  print("Move up");
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && currentSnakeDirection != snake_direction.LEFT) {
                  currentSnakeDirection = snake_direction.RIGHT;
                  print("Move right");
                }
                else if (details.delta.dx < 0 && currentSnakeDirection != snake_direction.RIGHT) {
                  currentSnakeDirection = snake_direction.LEFT;
                  print("Move left");
                }
              },
              child: GridView.builder(
                  itemCount: totalNumberOfSquares,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return SnakePixel();
                    } else if (foodPos == index) {
                      return FoodPixel();
                    } else {
                      return BlankPixel();
                    }
                  }),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  child: Text('Start Game'),
                  color: Colors.blue[900],
                  onPressed: _startGame,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
