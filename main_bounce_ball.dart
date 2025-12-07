import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bounce Ball',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BallSimulatorPage(),
    );
  }
}

class Ball {
  double x;
  double y;
  double velocityX;
  double velocityY;
  Color color;

  Ball({
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    required this.color,
  });
}

class BallSimulatorPage extends StatefulWidget {
  const BallSimulatorPage({Key? key}) : super(key: key);

  @override
  State<BallSimulatorPage> createState() => _BallSimulatorPageState();
}

class _BallSimulatorPageState extends State<BallSimulatorPage> {
  late Timer _timer;
  List<Ball> balls = [];
  double ballRadius = 25;
  final double gravity = 0.5;
  final double friction = 0.98;
  final double bounce = 0.8;
  bool isDragging = false;
  Offset dragStart = Offset.zero;
  int? draggingBallIndex;

  @override
  void initState() {
    super.initState();
    _initializeBalls();
    _startSimulation();
  }

  void _initializeBalls() {
    balls = [
      Ball(x: 100, y: 100, velocityX: 2, velocityY: 0, color: Colors.blue),
      Ball(x: 200, y: 150, velocityX: -2, velocityY: 1, color: Colors.red),
      Ball(x: 300, y: 80, velocityX: 1.5, velocityY: -1, color: Colors.green),
      Ball(x: 150, y: 200, velocityX: -1, velocityY: 0.5, color: Colors.purple),
      Ball(x: 250, y: 120, velocityX: 0, velocityY: 1, color: Colors.orange),
    ];
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        _updateBallsPhysics();
      });
    });
  }

  void _updateBallsPhysics() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    for (var ball in balls) {
      if (draggingBallIndex != null && balls.indexOf(ball) == draggingBallIndex) {
        continue;
      }

      // 중력 적용
      ball.velocityY += gravity;

      // 마찰력 적용
      ball.velocityX *= friction;
      ball.velocityY *= friction;

      // 위치 업데이트
      ball.x += ball.velocityX;
      ball.y += ball.velocityY;

      // 왼쪽 벽 충돌
      if (ball.x - ballRadius < 0) {
        ball.x = ballRadius;
        ball.velocityX *= -bounce;
      }

      // 오른쪽 벽 충돌
      if (ball.x + ballRadius > screenWidth) {
        ball.x = screenWidth - ballRadius;
        ball.velocityX *= -bounce;
      }

      // 하단 벽 충돌
      if (ball.y + ballRadius > screenHeight) {
        ball.y = screenHeight - ballRadius;
        ball.velocityY *= -bounce;

        if (ball.velocityY.abs() < 1 && ball.velocityX.abs() < 1) {
          ball.velocityY = 0;
          ball.velocityX = 0;
        }
      }

      // 상단 충돌
      if (ball.y - ballRadius < 0) {
        ball.y = ballRadius;
        ball.velocityY *= -bounce;
      }
    }
  }

  void _onDragStart(DragStartDetails details) {
    dragStart = details.localPosition;
    isDragging = true;

    for (int i = 0; i < balls.length; i++) {
      double distance = (details.localPosition - Offset(balls[i].x, balls[i].y)).distance;
      if (distance < ballRadius) {
        draggingBallIndex = i;
        break;
      }
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (draggingBallIndex != null) {
      setState(() {
        balls[draggingBallIndex!].x = details.localPosition.dx;
        balls[draggingBallIndex!].y = details.localPosition.dy;
      });
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (draggingBallIndex != null) {
      double deltaX = details.globalPosition.dx - dragStart.dx;
      double deltaY = details.globalPosition.dy - dragStart.dy;

      balls[draggingBallIndex!].velocityX = -deltaX * 0.1;
      balls[draggingBallIndex!].velocityY = -deltaY * 0.1;
      draggingBallIndex = null;
    }

    isDragging = false;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bounce Ball Simulator')),
      body: GestureDetector(
        onPanStart: _onDragStart,
        onPanUpdate: _onDragUpdate,
        onPanEnd: _onDragEnd,
        child: Container(
          color: Colors.grey[200],
          child: Stack(
            children: [
              for (int i = 0; i < balls.length; i++)
                Positioned(
                  left: balls[i].x - ballRadius,
                  top: balls[i].y - ballRadius,
                  child: _buildBall(balls[i], i),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBall(Ball ball, int index) {
    return Container(
      width: ballRadius * 2,
      height: ballRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            ball.color.withOpacity(0.9),
            ball.color,
            ball.color.withOpacity(0.7),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: ballRadius * 0.3,
            top: ballRadius * 0.3,
            child: Container(
              width: ballRadius * 0.6,
              height: ballRadius * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
