import 'package:flutter/material.dart';

/// Aparición elegante: fade + slide-up al construirse, con retardo escalonado
/// según [index]. Útil para que el contenido de una pantalla "se despliegue".
class Appear extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;
  final double offsetY;
  const Appear({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelay = const Duration(milliseconds: 70),
    this.offsetY = 18,
  });

  @override
  State<Appear> createState() => _AppearState();
}

class _AppearState extends State<Appear> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    Future.delayed(widget.baseDelay * widget.index, () {
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
      animation: _a,
      builder: (context, child) => Opacity(
        opacity: _a.value,
        child: Transform.translate(offset: Offset(0, (1 - _a.value) * widget.offsetY), child: child),
      ),
      child: widget.child,
    );
  }
}
