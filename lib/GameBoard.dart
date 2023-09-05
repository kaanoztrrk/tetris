import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/Piece.dart';
import 'package:tetris/Pixel.dart';
import 'package:tetris/Values.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int rowLength = 10;
  int colLength = 15;

  Piece currentPiece = Piece(type: Tetromino.J);
  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    Duration frameRate = const Duration(milliseconds: 400);
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          checkLanding();
          currentPiece.movePiece(Direction.down);
        });
      },
    );
  }

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = (currentPiece.position[i] % rowLength);
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.rigth) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
          itemCount: rowLength * colLength,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowLength),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            int row = (index / rowLength).floor();
            int col = index % rowLength;
            if (currentPiece.position.contains(index)) {
              return Pixel(
                color: Colors.yellow,
                child: index,
              );
            } else if (gameBoard[row][col] != null) {
              // final Tetromino? tetrominoType = gameBoard[row][col];
              return Pixel(color: Colors.red, child: "");
            } else {
              return Pixel(
                color: Colors.grey.shade900,
                child: index,
              );
            }
          }),
    );
  }
}
