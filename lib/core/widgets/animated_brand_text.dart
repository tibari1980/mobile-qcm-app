import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AnimatedBrandText extends StatefulWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlign;
  final double letterSpacing;
  final double height;
  final Color? color;

  const AnimatedBrandText({
    super.key,
    required this.text,
    this.fontSize = 14.0,
    this.textAlign = TextAlign.center,
    this.letterSpacing = 2.0,
    this.height = 1.1,
    this.color,
  });

  @override
  State<AnimatedBrandText> createState() => _AnimatedBrandTextState();
}

class _AnimatedBrandTextState extends State<AnimatedBrandText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    if (!kIsWeb) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final style = TextStyle(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: widget.letterSpacing,
      height: widget.height,
      color: widget.color ?? (isDark ? Colors.white : Colors.black87),
    );

    if (kIsWeb) {
      return Text(
        widget.text,
        textAlign: widget.textAlign,
        style: style,
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // 3D Shadow Layer 1 (France Red)
              Transform.translate(
                offset: const Offset(1.5, 1.5),
                child: Text(
                  widget.text,
                  textAlign: widget.textAlign,
                  style: style.copyWith(
                    color: isDark 
                        ? const Color(0xFFFF1744).withValues(alpha: 0.4)
                        : const Color(0xFFD32F2F).withValues(alpha: 0.3),
                    shadows: isDark ? [const Shadow(color: Color(0xFFFF1744), blurRadius: 4)] : [],
                  ),
                ),
              ),
              // 3D Shadow Layer 2 (France Blue)
              Transform.translate(
                offset: const Offset(-1.5, -1.5),
                child: Text(
                  widget.text,
                  textAlign: widget.textAlign,
                  style: style.copyWith(
                    color: isDark 
                        ? const Color(0xFF00E5FF).withValues(alpha: 0.4)
                        : const Color(0xFF1976D2).withValues(alpha: 0.3),
                    shadows: isDark ? [const Shadow(color: Color(0xFF00E5FF), blurRadius: 4)] : [],
                  ),
                ),
              ),
              // Front Layer with Moving Shimmer Gradient
              ShaderMask(
                shaderCallback: (bounds) {
                  if (bounds.width <= 0 || bounds.height <= 0) {
                    return const LinearGradient(colors: [Colors.white, Colors.white]).createShader(bounds);
                  }
                  
                  return LinearGradient(
                    colors: [
                      isDark ? const Color(0xFF00E5FF) : const Color(0xFF1976D2),
                      isDark ? Colors.white : Colors.black87,
                      isDark ? const Color(0xFFFF1744) : const Color(0xFFD32F2F),
                      isDark ? Colors.white : Colors.black87,
                      isDark ? const Color(0xFF00E5FF) : const Color(0xFF1976D2),
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    begin: Alignment(-1.5 + (_controller.value * 2), 0.0),
                    end: Alignment(1.5 + (_controller.value * 2), 0.0),
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Text(
                  widget.text,
                  textAlign: widget.textAlign,
                  style: style.copyWith(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
