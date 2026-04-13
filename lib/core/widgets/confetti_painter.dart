import 'dart:math';

import 'package:flutter/material.dart';



class ConfettiPainter extends CustomPainter {

  final Animation<double> animation;

  final Random random = Random();

  final List<Confetto> confetti = List.generate(50, (i) => Confetto());



  ConfettiPainter({required this.animation}) : super(repaint: animation);



  @override

  void paint(Canvas canvas, Size size) {

    if (!size.isFinite) return;

    for (var confetto in confetti) {

      final progress = (animation.value + confetto.startTime) % 1.0;

      final y = progress * size.height;

      final x = confetto.x * size.width + sin(progress * 10) * 20;

      

      final paint = Paint()

        ..color = confetto.color.withValues(alpha: 1.0 - progress)



        ..style = PaintingStyle.fill;



      canvas.save();

      canvas.translate(x, y);

      canvas.rotate(progress * confetto.rotationSpeed);

      canvas.drawRect(Rect.fromLTWH(0, 0, confetto.size, confetto.size * 0.6), paint);

      canvas.restore();

    }

  }



  @override

  bool shouldRepaint(ConfettiPainter oldDelegate) => true;

}



class Confetto {

  final double x = Random().nextDouble();

  final double startTime = Random().nextDouble();

  final Color color = [

    Colors.redAccent,

    Colors.blueAccent,

    Colors.greenAccent,

    Colors.yellowAccent,

    Colors.orangeAccent,

    Colors.purpleAccent,

  ][Random().nextInt(6)];

  final double size = Random().nextDouble() * 8 + 4;

  final double rotationSpeed = Random().nextDouble() * 10;

}

