import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Número que cuenta desde 0 hasta [value] al aparecer.
class CountUp extends StatelessWidget {
  final num value;
  final int decimals;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;
  const CountUp({
    super.key,
    required this.value,
    this.decimals = 0,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(value),
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => Text('$prefix${v.toStringAsFixed(decimals)}$suffix', style: style),
    );
  }
}

/// Aparece con un "pop": escala 0.8→1.0 (overshoot leve) + fade.
class PopIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  const PopIn({super.key, required this.child, this.delay = Duration.zero, this.duration = const Duration(milliseconds: 440)});

  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final s = lerpDouble(0.8, 1.0, Curves.easeOutBack.transform(_c.value))!;
        return Opacity(
          opacity: Curves.easeOut.transform(_c.value),
          child: Transform.scale(scale: s, child: child),
        );
      },
      child: widget.child,
    );
  }
}

/// Flotación continua y suave (bob vertical). Para sprites/íconos.
class Floating extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration period;
  const Floating({super.key, required this.child, this.amplitude = 8, this.period = const Duration(milliseconds: 2200)});

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.period)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final v = Curves.easeInOut.transform(_c.value); // 0..1
        return Transform.translate(offset: Offset(0, (v - 0.5) * 2 * widget.amplitude), child: child);
      },
      child: widget.child,
    );
  }
}
