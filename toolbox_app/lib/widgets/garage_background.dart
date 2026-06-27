import 'package:flutter/material.dart';

/// Fondo estilo garaje real: techo de madera + viga, tira LED, pared con
/// pegboard y herramientas colgadas, gabinete rojo con tope de madera (donde
/// se posa la caja) y piso claro. Todo vectorial (sin imágenes).
class GarageBackground extends StatelessWidget {
  const GarageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(child: CustomPaint(painter: _GaragePainter()));
  }
}

class _GaragePainter extends CustomPainter {
  const _GaragePainter();

  // niveles verticales (fracción de alto)
  static const double _ceil = 0.12;
  static const double _led = 0.135;
  static const double _counter = 0.74; // superficie de madera: aquí se posa la caja
  static const double _woodBot = 0.775;
  static const double _floor = 0.92;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    _wall(canvas, w, h);
    _ceiling(canvas, w, h);
    _ledStrip(canvas, w, h);
    _pegboard(canvas, w, h);
    _tools(canvas, w, h);
    _drawFloor(canvas, w, h);
    _bench(canvas, w, h);
    _lightAndVignette(canvas, w, h);
  }

  void _wall(Canvas canvas, double w, double h) {
    canvas.drawRect(
      Rect.fromLTRB(0, h * _led, w, h * _floor),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF494D50), Color(0xFF3A3E41)],
        ).createShader(Rect.fromLTRB(0, 0, w, h)),
    );
  }

  void _ceiling(Canvas canvas, double w, double h) {
    final c = Rect.fromLTRB(0, 0, w, h * _ceil);
    canvas.drawRect(
      c,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF7A5C3A), Color(0xFF634A2E)],
        ).createShader(c),
    );
    // tablas (líneas en perspectiva hacia el centro)
    final plank = Paint()..color = const Color(0xFF4D3A23).withOpacity(0.7)..strokeWidth = 1.4;
    for (int i = 1; i < 7; i++) {
      final x = w * i / 7;
      canvas.drawLine(Offset(x, 0), Offset(w * 0.5 + (x - w * 0.5) * 0.2, h * _ceil), plank);
    }
    // viga frontal (borde inferior del techo)
    canvas.drawRect(
      Rect.fromLTRB(0, h * _ceil - h * 0.022, w, h * _ceil),
      Paint()..color = const Color(0xFF3F2F1D),
    );
  }

  void _ledStrip(Canvas canvas, double w, double h) {
    final y = h * _ceil + h * 0.006;
    // barra brillante
    canvas.drawRRect(
      RRect.fromLTRBR(w * 0.10, y, w * 0.90, y + h * 0.012, const Radius.circular(6)),
      Paint()..color = const Color(0xFFFFF8E7),
    );
    // resplandor hacia abajo
    canvas.drawRect(
      Rect.fromLTRB(0, y, w, y + h * 0.16),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFF3D0).withOpacity(0.20),
            const Color(0xFFFFF3D0).withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTRB(0, y, w, y + h * 0.16)),
    );
  }

  void _pegboard(Canvas canvas, double w, double h) {
    final top = h * (_led + 0.04), bot = h * _counter;
    final r = Rect.fromLTRB(w * 0.05, top, w * 0.95, bot);
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(4)),
      Paint()..color = const Color(0xFF2E3236),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(4)),
      Paint()
        ..color = const Color(0xFF141618).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // agujeros (cuadrícula)
    final hole = Paint()..color = Colors.black.withOpacity(0.30);
    const sp = 22.0;
    for (double x = r.left + 14; x < r.right - 6; x += sp) {
      for (double y = top + 14; y < bot - 6; y += sp) {
        canvas.drawCircle(Offset(x, y), 1.3, hole);
      }
    }
  }

  // paletas compartidas
  static const _steel = Color(0xFFC2C7CA);
  static const _steelD = Color(0xFF8A9094);
  static const _wood = Color(0xFF9A6A35);
  static const _woodD = Color(0xFF73501F);
  static const _rubber = Color(0xFF34373A);
  static const _red = Color(0xFFC62F28);
  static const _yellow = Color(0xFFE8C547);

  void _tools(Canvas canvas, double w, double h) {
    _hammer(canvas, w * 0.11, h * 0.26, w * 0.072);
    _wrench(canvas, w * 0.23, h * 0.25, w * 0.066);
    _screwdriver(canvas, w * 0.32, h * 0.27, w * 0.06, _red);
    _screwdriver(canvas, w * 0.37, h * 0.27, w * 0.06, _yellow);
    _pliers(canvas, w * 0.45, h * 0.26, w * 0.07);
    _handsaw(canvas, w * 0.78, h * 0.27, w * 0.24);
    _level(canvas, w * 0.27, h * 0.60, w * 0.40);
    _tape(canvas, w * 0.66, h * 0.58, w * 0.085);
    _redBin(canvas, w * 0.84, h * 0.56, w * 0.10);
  }

  void _hook(Canvas canvas, double cx, double top) {
    canvas.drawCircle(Offset(cx, top), 2.2, Paint()..color = const Color(0xFF15171A));
  }

  void _hammer(Canvas canvas, double cx, double top, double s) {
    _hook(canvas, cx, top);
    final hy = top + s * 0.6;
    // mango
    final hw = s * 0.28;
    final hTop = hy + s * 0.2, hBot = top + s * 2.7;
    canvas.drawRRect(RRect.fromLTRBR(cx - hw / 2, hTop, cx + hw / 2, hBot, Radius.circular(hw / 2)),
        Paint()..color = _wood);
    canvas.drawRRect(RRect.fromLTRBR(cx + hw * 0.05, hTop, cx + hw / 2, hBot, Radius.circular(hw / 2)),
        Paint()..color = _woodD);
    // grip de goma
    canvas.drawRRect(RRect.fromLTRBR(cx - hw / 2, hBot - s * 0.8, cx + hw / 2, hBot, Radius.circular(hw / 2)),
        Paint()..color = _rubber);
    // cabeza: cara de golpe (derecha)
    canvas.drawRRect(RRect.fromLTRBR(cx - s * 0.06, hy - s * 0.32, cx + s * 0.58, hy + s * 0.30, const Radius.circular(3)),
        Paint()..color = _steelD);
    canvas.drawRRect(RRect.fromLTRBR(cx + s * 0.40, hy - s * 0.32, cx + s * 0.58, hy + s * 0.30, const Radius.circular(3)),
        Paint()..color = _steel);
    // garra (izquierda)
    final claw = Path()
      ..moveTo(cx - s * 0.02, hy - s * 0.28)
      ..quadraticBezierTo(cx - s * 0.45, hy - s * 0.34, cx - s * 0.66, hy + s * 0.02)
      ..lineTo(cx - s * 0.56, hy + s * 0.10)
      ..quadraticBezierTo(cx - s * 0.38, hy - s * 0.02, cx - s * 0.02, hy + s * 0.26)
      ..close();
    canvas.drawPath(claw, Paint()..color = _steel);
    // hendidura de la garra
    canvas.drawLine(Offset(cx - s * 0.5, hy - s * 0.02), Offset(cx - s * 0.66, hy + s * 0.02),
        Paint()..color = const Color(0xFF2E3236)..strokeWidth = 2);
  }

  void _wrench(Canvas canvas, double cx, double top, double s) {
    _hook(canvas, cx, top);
    final p = Paint()..color = _steel;
    final shaftW = s * 0.22;
    final t = top + s * 0.5, b = top + s * 3.0;
    canvas.drawRRect(RRect.fromLTRBR(cx - shaftW / 2, t, cx + shaftW / 2, b, Radius.circular(shaftW / 2)), p);
    canvas.drawRRect(RRect.fromLTRBR(cx, t, cx + shaftW / 2, b, Radius.circular(shaftW / 2)), Paint()..color = _steelD);
    // anillo cerrado (arriba)
    canvas.drawCircle(Offset(cx, t), s * 0.42, p);
    canvas.drawCircle(Offset(cx, t), s * 0.20, Paint()..color = const Color(0xFF2E3236));
    // boca abierta (abajo, herradura)
    final jaw = Path()
      ..moveTo(cx - s * 0.40, b + s * 0.20)
      ..lineTo(cx - s * 0.40, b)
      ..arcToPoint(Offset(cx + s * 0.40, b), radius: Radius.circular(s * 0.40))
      ..lineTo(cx + s * 0.40, b + s * 0.20)
      ..lineTo(cx + s * 0.18, b + s * 0.20)
      ..lineTo(cx + s * 0.18, b)
      ..arcToPoint(Offset(cx - s * 0.18, b), radius: Radius.circular(s * 0.18), clockwise: false)
      ..lineTo(cx - s * 0.18, b + s * 0.20)
      ..close();
    canvas.drawPath(jaw, p);
  }

  void _screwdriver(Canvas canvas, double cx, double top, double s, Color handle) {
    _hook(canvas, cx, top);
    // mango bulboso
    final hw = s * 0.5;
    final hTop = top + s * 0.3, hBot = top + s * 1.5;
    canvas.drawRRect(RRect.fromLTRBR(cx - hw / 2, hTop, cx + hw / 2, hBot, Radius.circular(hw * 0.4)),
        Paint()..color = handle);
    canvas.drawRRect(RRect.fromLTRBR(cx + hw * 0.1, hTop, cx + hw / 2, hBot, Radius.circular(hw * 0.4)),
        Paint()..color = handle.withOpacity(0.65));
    // vástago metálico
    canvas.drawRRect(RRect.fromLTRBR(cx - s * 0.07, hBot - s * 0.1, cx + s * 0.07, top + s * 2.6, const Radius.circular(2)),
        Paint()..color = _steel);
    // punta plana
    canvas.drawRect(Rect.fromLTRB(cx - s * 0.12, top + s * 2.6, cx + s * 0.12, top + s * 2.75),
        Paint()..color = _steelD);
  }

  void _pliers(Canvas canvas, double cx, double top, double s) {
    _hook(canvas, cx, top);
    final steel = Paint()
      ..color = _steel
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.16
      ..strokeCap = StrokeCap.round;
    final grip = Paint()
      ..color = _red
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.22
      ..strokeCap = StrokeCap.round;
    final pivot = Offset(cx, top + s * 1.1);
    // nariz (puntas)
    canvas.drawLine(Offset(cx - s * 0.12, top + s * 0.1), pivot, steel);
    canvas.drawLine(Offset(cx + s * 0.12, top + s * 0.1), pivot, steel);
    // mangos cruzados (rojos)
    canvas.drawLine(pivot, Offset(cx - s * 0.5, top + s * 2.9), grip);
    canvas.drawLine(pivot, Offset(cx + s * 0.5, top + s * 2.9), grip);
    // tornillo del pivote
    canvas.drawCircle(pivot, s * 0.16, Paint()..color = _steelD);
  }

  void _handsaw(Canvas canvas, double cx, double top, double s) {
    // serrucho horizontal: mango (izq) + hoja triangular con dientes
    final hx = cx - s * 0.5;
    _hook(canvas, hx + s * 0.06, top - s * 0.04);
    final y0 = top;
    // mango tipo pistola
    final handle = Path()
      ..moveTo(hx - s * 0.02, y0 - s * 0.10)
      ..lineTo(hx + s * 0.18, y0 - s * 0.10)
      ..lineTo(hx + s * 0.18, y0 + s * 0.22)
      ..quadraticBezierTo(hx + s * 0.10, y0 + s * 0.30, hx - s * 0.04, y0 + s * 0.24)
      ..quadraticBezierTo(hx - s * 0.16, y0 + s * 0.10, hx - s * 0.02, y0 - s * 0.10)
      ..close();
    canvas.drawPath(handle, Paint()..color = _wood);
    // agujero del mango
    canvas.drawCircle(Offset(hx + s * 0.07, y0 + s * 0.07), s * 0.06, Paint()..color = const Color(0xFF2E3236));
    // hoja
    final blade = Path()
      ..moveTo(hx + s * 0.16, y0 - s * 0.06)
      ..lineTo(hx + s * 1.0, y0 - s * 0.02)
      ..lineTo(hx + s * 0.95, y0 + s * 0.08)
      ..lineTo(hx + s * 0.16, y0 + s * 0.10)
      ..close();
    canvas.drawPath(blade, Paint()..color = _steel);
    // dientes
    final teeth = Paint()..color = _steelD;
    for (double tx = hx + s * 0.2; tx < hx + s * 0.92; tx += s * 0.045) {
      final ty = y0 + s * 0.10 + (tx - hx) * 0.0;
      canvas.drawPath(
        Path()
          ..moveTo(tx, ty)
          ..lineTo(tx + s * 0.022, ty)
          ..lineTo(tx + s * 0.011, ty + s * 0.06)
          ..close(),
        teeth,
      );
    }
  }

  void _level(Canvas canvas, double cx, double top, double len) {
    final h = len * 0.12;
    final r = Rect.fromLTWH(cx - len / 2, top, len, h);
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(4)), Paint()..color = _yellow);
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(4)),
        Paint()..color = const Color(0xFFB89A2E)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    // burbujas (vials)
    for (final fx in [0.5, 0.18, 0.82]) {
      final bx = r.left + len * fx;
      final br = Rect.fromCenter(center: Offset(bx, r.center.dy), width: len * 0.10, height: h * 0.5);
      canvas.drawRRect(RRect.fromRectAndRadius(br, const Radius.circular(3)), Paint()..color = const Color(0xFFCFE8B0));
      canvas.drawCircle(Offset(bx, r.center.dy), h * 0.12, Paint()..color = const Color(0xFF7FB04A));
    }
  }

  void _tape(Canvas canvas, double cx, double top, double s) {
    _hook(canvas, cx, top);
    // cuerpo (carcasa redondeada)
    final body = RRect.fromLTRBR(cx - s * 0.7, top + s * 0.2, cx + s * 0.7, top + s * 1.7, Radius.circular(s * 0.35));
    canvas.drawRRect(body, Paint()..color = _red);
    canvas.drawRRect(RRect.fromLTRBR(cx - s * 0.7, top + s * 0.2, cx + s * 0.7, top + s * 0.6, Radius.circular(s * 0.3)),
        Paint()..color = const Color(0xFF8C1F19));
    // lengüeta metálica
    canvas.drawRect(Rect.fromLTRB(cx - s * 0.15, top + s * 1.6, cx + s * 0.15, top + s * 1.95),
        Paint()..color = _steel);
    // ranura
    canvas.drawRect(Rect.fromLTRB(cx - s * 0.5, top + s * 1.55, cx + s * 0.5, top + s * 1.62),
        Paint()..color = const Color(0xFF2E3236));
  }

  void _redBin(Canvas canvas, double cx, double top, double s) {
    final r = RRect.fromLTRBR(cx - s / 2, top, cx + s / 2, top + s * 0.85, const Radius.circular(5));
    canvas.drawRRect(r, Paint()..color = _red);
    // boca abierta (más oscura)
    canvas.drawRRect(RRect.fromLTRBR(cx - s / 2, top, cx + s / 2, top + s * 0.22, const Radius.circular(5)),
        Paint()..color = const Color(0xFF8C1F19));
    // etiqueta
    canvas.drawRRect(RRect.fromLTRBR(cx - s * 0.22, top + s * 0.45, cx + s * 0.22, top + s * 0.65, const Radius.circular(2)),
        Paint()..color = const Color(0xFFE8DCC0));
  }

  void _drawFloor(Canvas canvas, double w, double h) {
    canvas.drawRect(
      Rect.fromLTRB(0, h * _floor, w, h),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF74787A), Color(0xFF5C6062)],
        ).createShader(Rect.fromLTRB(0, h * _floor, w, h)),
    );
    // brillo/junta del piso
    canvas.drawLine(Offset(0, h * _floor), Offset(w, h * _floor),
        Paint()..color = const Color(0xFF85898B)..strokeWidth = 2);
  }

  void _bench(Canvas canvas, double w, double h) {
    final l = w * 0.05, r = w * 0.95;
    final counterY = h * _counter, woodBot = h * _woodBot, floorY = h * _floor;

    // gabinete rojo (cuerpo)
    final cab = Rect.fromLTRB(l, woodBot, r, floorY);
    canvas.drawRect(
      cab,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD2362C), Color(0xFF9E1E17)],
        ).createShader(cab),
    );
    // cajones + tiradores cromados
    final line = Paint()..color = const Color(0xFF6E140F)..strokeWidth = 2;
    final handle = Paint()..color = const Color(0xFFC8CCCE);
    final drawers = 3;
    for (int i = 1; i <= drawers; i++) {
      final y = woodBot + (floorY - woodBot) * i / (drawers + 1);
      canvas.drawLine(Offset(l, y), Offset(r, y), line);
      // tiradores (varios módulos)
      for (double cx = l + w * 0.12; cx < r; cx += w * 0.22) {
        canvas.drawRRect(RRect.fromLTRBR(cx - w * 0.05, y - 6, cx + w * 0.05, y - 2, const Radius.circular(2)), handle);
      }
    }
    // divisiones verticales entre módulos
    for (double cx = l + w * 0.225; cx < r - w * 0.05; cx += w * 0.225) {
      canvas.drawLine(Offset(cx, woodBot), Offset(cx, floorY), line);
    }

    // tope de madera (butcher block) — la caja se apoya aquí
    final wood = Rect.fromLTRB(l - w * 0.01, counterY, r + w * 0.01, woodBot);
    canvas.drawRect(
      wood,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF9A7647), Color(0xFF6F5230)],
        ).createShader(wood),
    );
    // canto superior iluminado
    canvas.drawRect(
      Rect.fromLTRB(wood.left, counterY, wood.right, counterY + h * 0.008),
      Paint()..color = const Color(0xFFB28A55),
    );
    // vetas de las tablas
    final grain = Paint()..color = const Color(0xFF4F3A21).withOpacity(0.6)..strokeWidth = 1.2;
    for (double gx = wood.left + w * 0.12; gx < wood.right; gx += w * 0.12) {
      canvas.drawLine(Offset(gx, counterY + 2), Offset(gx, woodBot), grain);
    }
  }

  void _lightAndVignette(Canvas canvas, double w, double h) {
    // foco cálido sobre la mesa
    canvas.drawRect(
      Rect.fromLTRB(0, 0, w, h),
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, 0.2),
          radius: 0.85,
          colors: [
            const Color(0xFFFFF3D6).withOpacity(0.10),
            const Color(0xFFFFF3D6).withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTRB(0, 0, w, h)),
    );
    // viñeta
    canvas.drawRect(
      Rect.fromLTRB(0, 0, w, h),
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 1.15,
          colors: [Colors.transparent, Colors.black.withOpacity(0.34)],
          stops: const [0.6, 1.0],
        ).createShader(Rect.fromLTRB(0, 0, w, h)),
    );
  }

  @override
  bool shouldRepaint(covariant _GaragePainter oldDelegate) => false;
}
