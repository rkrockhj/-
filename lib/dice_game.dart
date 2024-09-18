import 'package:flutter/material.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';
// import 'package:flutter/animation.dart'; // 新增动画包
import 'dart:async'; // 新增定时器库
import 'package:flutter_tts/flutter_tts.dart'; // 新增文字转语音库

class DiceGame extends StatefulWidget {
  @override
  _DiceGameState createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame>
    with SingleTickerProviderStateMixin {
  List<int> diceValues = List.filled(6, 1);
  bool isRolling = false;
  late ConfettiController _confettiController; // 使用 'late' 关键字
  late AnimationController _shakeController; // 新增摇动动画控制器
  late Animation<double> _shakeAnimation; // 新增摇动动画
  late Timer _diceTimer; // 新增定时器
  String result = ""; // 新增用于显示结果的变量
  String rank = "未中奖"; // 新增用于显示段位的变量
  late FlutterTts _flutterTts; // 新增 TTS 变量

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    // 初始化摇动动画控制器
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    // 定义摇动动画范围
    _shakeAnimation =
        Tween<double>(begin: -10, end: 10).animate(_shakeController);

    // 初始化 TTS
    _flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _shakeController.dispose(); // 释放摇动动画控制器
    _flutterTts.stop(); // 停止 TTS
    super.dispose();
  }

  void startGame() {
    setState(() {
      isRolling = true;
      // 放烟花效果和显示"开始摇了"
      _confettiController.play(); // 开始烟花动画
      _shakeController.forward(); // 开始摇动动画

      _diceTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {
          diceValues = List.generate(6, (_) => Random().nextInt(6) + 1);
        });
      });
    });
  }

  void stopGame() {
    if (isRolling) {
      _diceTimer.cancel(); // 停止定时器
      setState(() {
        isRolling = false;
        _shakeController.stop(); // 停止摇动动画
        determineRank();
      });
    }
  }

  void rollDice() async {
    // 模拟骰子转动
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isRolling = false;
      diceValues = List.generate(6, (_) => Random().nextInt(6) + 1);
      _shakeController.stop(); // 停止摇动动画
      determineRank();
    });
  }

  void determineRank() {
    rank = determineRankLogic(diceValues); // 使用独立的逻辑函数

    setState(() {
      result = "点数: ${diceValues.join(' ')}\n段位: $rank"; // 更新结果
    });

    // 如果段位有奖，则播报
    if (rank != "未中奖") {
      _flutterTts.speak(rank);
    } else {
      _flutterTts.speak("摇到蛋了");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isRolling ? stopGame : startGame, // 点击开始或停止
      child: Stack(
        children: [
          // 背景图片
          Positioned.fill(
            child: Image.asset(
              'images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // 显示结果
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150), // 向上偏移
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "点数: ",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red, // 高对比色
                      ),
                    ),
                    TextSpan(
                      text: "${diceValues.join(' ')}\n",
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.red, // 高对比色
                      ),
                    ),
                    TextSpan(
                      text: "[  $rank  ]",
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow, // 高对比色
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 博饼碗中的骰子
          Positioned(
            bottom: 100,
            left: 50,
            right: 50,
            child: _buildDice(), // 使用带有摇动效果的骰子
          ),
          // 烟花效果
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // 全方向爆炸
              maxBlastForce: 8, // 稍微降低最大爆炸力度
              minBlastForce: 3, // 稍微降低最小爆炸力度
              emissionFrequency: 0.2, // 降低发射频率
              numberOfParticles: 5, // 减少粒子数量
              gravity: 0.5, // 增加重力使粒子更快落下
              colors: [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
              shouldLoop: false, // 不循环
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDice() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0), // 应用摇动偏移
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: diceValues
                .map((value) => ClipRRect(
                      borderRadius: BorderRadius.circular(10), // 增加圆角
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // 骰子背景色
                          borderRadius: BorderRadius.circular(10), // 圆角
                          border: Border.all(
                              color: Colors.white, width: 2), // 添加白色边框
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // 阴影颜色
                              offset: Offset(2, 2), // 阴影偏移
                              blurRadius: 5, // 模糊半径
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          size: Size(50, 50),
                          painter: DicePainter(value),
                        ),
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class DicePainter extends CustomPainter {
  final int value;
  DicePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 绘制骰子方块
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), border);

    // 绘制点数
    final dotPaint = Paint()
      ..color =
          (value == 4 || value == 6) ? Colors.red : Colors.black; // 修改点数颜色
    final dotRadius = 4.0;
    final centers = _getDotCenters(value, size);

    for (var center in centers) {
      canvas.drawCircle(center, dotRadius, dotPaint);
    }
  }

  List<Offset> _getDotCenters(int value, Size size) {
    switch (value) {
      case 1:
        return [Offset(size.width / 2, size.height / 2)];
      case 2:
        return [
          Offset(size.width * 0.25, size.height * 0.25),
          Offset(size.width * 0.75, size.height * 0.75),
        ];
      case 3:
        return [
          Offset(size.width * 0.25, size.height * 0.25),
          Offset(size.width / 2, size.height / 2),
          Offset(size.width * 0.75, size.height * 0.75),
        ];
      case 4:
        return [
          Offset(size.width * 0.25, size.height * 0.25),
          Offset(size.width * 0.75, size.height * 0.25),
          Offset(size.width * 0.25, size.height * 0.75),
          Offset(size.width * 0.75, size.height * 0.75),
        ];
      case 5:
        return [
          Offset(size.width * 0.25, size.height * 0.25),
          Offset(size.width * 0.75, size.height * 0.25),
          Offset(size.width / 2, size.height / 2),
          Offset(size.width * 0.25, size.height * 0.75),
          Offset(size.width * 0.75, size.height * 0.75),
        ];
      case 6:
        return [
          Offset(size.width * 0.25, size.height * 0.2),
          Offset(size.width * 0.25, size.height * 0.5),
          Offset(size.width * 0.25, size.height * 0.8),
          Offset(size.width * 0.75, size.height * 0.2),
          Offset(size.width * 0.75, size.height * 0.5),
          Offset(size.width * 0.75, size.height * 0.8),
        ];
      default:
        return [];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// lib/dice_game.dart
String determineRankLogic(List<int> diceValues) {
  Map<int, int> counts = {};
  for (var value in diceValues) {
    counts[value] = (counts[value] ?? 0) + 1;
  }

  String rank = "未中奖"; // 默认状态

  if (counts.length == 1) {
    if (diceValues[0] == 4) {
      rank = "红六勃 - 状元";
    } else if (diceValues[0] == 1) {
      rank = "遍地锦 - 状元";
    } else {
      rank = "黑六勃 - 状元";
    }
  }
  // 添加插金花规则
  else if (counts[4] == 4 && counts[1] == 2) {
    rank = "插金花 - 状元";
  } else if (counts.length == 6) {
    // 修改条件，确保每个骰子各出现一次
    rank = "对堂 - 榜眼";
  } else {
    if (counts[4] == 5) {
      rank = "五红 - 五红";
    } else if (counts.containsKey(4)) {
      if (counts[4] == 4) {
        rank = "四红 - 四红";
      } else if (counts[4] == 3) {
        rank = "三红 - 探花";
      } else if (counts[4] == 2) {
        rank = "二举 - 举人";
      } else if (counts[4] == 1) {
        rank = "一秀 - 秀才";
      }
    }

    // 检查五子登科和四进
    counts.forEach((key, value) {
      if (value == 5 && key != 4) {
        rank = "五子登科 - 五子登科";
      }
      if (value == 4 && key != 4) {
        rank = "四进 - 进士";
      }
    });
  }

  return rank;
}
