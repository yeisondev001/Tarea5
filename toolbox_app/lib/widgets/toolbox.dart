import 'package:flutter/material.dart';

/// Caja de herramientas roja estilo URREA, dibujada vectorialmente.
/// [lidProgress] 0 = cerrada, 1 = tapa totalmente abierta.
class Toolbox extends StatelessWidget {
  final double lidProgress;
  final double size;
  const Toolbox({super.key, this.lidProgress = 0, this.size = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ToolboxPainter(lidProgress)),
    );
  }
}

class _ToolboxPainter extends CustomPainter {
  final double lid;
  _ToolboxPainter(this.lid);

  static const _redLight = Color(0xFFF4655A);
  static const _redMain = Color(0xFFDE3B2E);
  static const _redDark = Color(0xFFB52219);
  static const _redDeep = Color(0xFF7E120B);
  static const _black = Color(0xFF202325);
  static const _blackDk = Color(0xFF111314);
  static const _blackHi = Color(0xFF52575B);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // ---------- CUERPO ----------
    final bodyL = w * 0.13, bodyR = w * 0.87;
    final bodyTop = h * 0.54, bodyBot = h * 0.82;
    final bodyRect = RRect.fromLTRBR(bodyL, bodyTop, bodyR, bodyBot, Radius.circular(w * 0.025));
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_redMain, _redDark],
        ).createShader(Rect.fromLTRB(bodyL, bodyTop, bodyR, bodyBot)),
    );
    // sombra del sobresaliente de la tapa (arriba del cuerpo)
    canvas.drawRRect(
      RRect.fromLTRBR(bodyL, bodyTop, bodyR, bodyTop + h * 0.045, Radius.circular(w * 0.025)),
      Paint()..color = Colors.black.withOpacity(0.20),
    );
    // brillo plástico lateral izquierdo (suave)
    canvas.drawRRect(
      RRect.fromLTRBR(bodyL + w * 0.01, bodyTop + h * 0.06, bodyL + w * 0.10, bodyBot - h * 0.04, Radius.circular(w * 0.04)),
      Paint()
        ..color = _redLight.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // base más oscura
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(bodyL, bodyBot - h * 0.05, bodyR, bodyBot,
          bottomLeft: Radius.circular(w * 0.025), bottomRight: Radius.circular(w * 0.025)),
      Paint()..color = _redDeep.withOpacity(0.5),
    );
    // contorno
    canvas.drawRRect(bodyRect, Paint()..color = _redDeep..style = PaintingStyle.stroke..strokeWidth = 1.2);

    // patitas
    final foot = Paint()..color = _blackDk;
    canvas.drawRRect(RRect.fromLTRBR(bodyL + w * 0.03, bodyBot - 1, bodyL + w * 0.13, bodyBot + h * 0.025, const Radius.circular(3)), foot);
    canvas.drawRRect(RRect.fromLTRBR(bodyR - w * 0.13, bodyBot - 1, bodyR - w * 0.03, bodyBot + h * 0.025, const Radius.circular(3)), foot);

    // ---------- TAPA (gira sobre la bisagra) ----------
    canvas.save();
    final hingeY = bodyTop;
    final angle = lid * 1.9;
    final m = Matrix4.identity()
      ..setEntry(3, 2, 0.0016)
      ..translate(0.0, hingeY)
      ..rotateX(-angle)
      ..translate(0.0, -hingeY);
    canvas.transform(m.storage);

    final lidL = w * 0.07, lidR = w * 0.93;
    final lidTop = h * 0.32, lidBot = h * 0.55; // sobresale por debajo del borde del cuerpo
    final lidRect = RRect.fromLTRBAndCorners(
      lidL, lidTop, lidR, lidBot,
      topLeft: Radius.circular(w * 0.075),
      topRight: Radius.circular(w * 0.075),
      bottomLeft: Radius.circular(w * 0.025),
      bottomRight: Radius.circular(w * 0.025),
    );
    canvas.drawRRect(
      lidRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_redLight, _redMain],
        ).createShader(Rect.fromLTRB(lidL, lidTop, lidR, lidBot)),
    );
    // labio frontal (sombra del sobresaliente) + borde inferior iluminado
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(lidL, lidBot - h * 0.035, lidR, lidBot,
          bottomLeft: Radius.circular(w * 0.025), bottomRight: Radius.circular(w * 0.025)),
      Paint()..color = _redDeep.withOpacity(0.45),
    );
    // brillo especular del top (suave)
    canvas.drawRRect(
      RRect.fromLTRBR(lidL + w * 0.05, lidTop + h * 0.012, lidR - w * 0.20, lidTop + h * 0.05, Radius.circular(w * 0.05)),
      Paint()
        ..color = Colors.white.withOpacity(0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    // contorno de la tapa
    canvas.drawRRect(lidRect, Paint()..color = _redDeep..style = PaintingStyle.stroke..strokeWidth = 1.2);

    // ---------- ASA (negra, sobre la tapa) ----------
    final hb = Paint()..color = _black;
    final hbDk = Paint()..color = _blackDk;
    // postes
    canvas.drawRRect(RRect.fromLTRBR(w * 0.375, h * 0.15, w * 0.435, h * 0.34, const Radius.circular(5)), hb);
    canvas.drawRRect(RRect.fromLTRBR(w * 0.565, h * 0.15, w * 0.625, h * 0.34, const Radius.circular(5)), hb);
    canvas.drawRRect(RRect.fromLTRBR(w * 0.42, h * 0.15, w * 0.435, h * 0.34, const Radius.circular(5)), hbDk);
    // barra de agarre
    canvas.drawRRect(RRect.fromLTRBR(w * 0.345, h * 0.095, w * 0.655, h * 0.175, Radius.circular(w * 0.04)), hb);
    canvas.drawRRect(RRect.fromLTRBR(w * 0.345, h * 0.15, w * 0.655, h * 0.175, Radius.circular(w * 0.04)), hbDk);
    // brillo del agarre
    canvas.drawRRect(RRect.fromLTRBR(w * 0.38, h * 0.105, w * 0.62, h * 0.125, const Radius.circular(6)),
        Paint()..color = _blackHi.withOpacity(0.8));

    canvas.restore();

    // ---------- BROCHES (negros, sobre la unión) ----------
    _latch(canvas, w, h, w * 0.235, bodyTop);
    _latch(canvas, w, h, w * 0.765, bodyTop);

    // cierre central
    canvas.drawRRect(RRect.fromLTRBR(w * 0.465, bodyTop - h * 0.045, w * 0.535, bodyTop + h * 0.03, const Radius.circular(3)),
        Paint()..color = _black);
    canvas.drawRRect(RRect.fromLTRBR(w * 0.482, bodyTop - h * 0.02, w * 0.518, bodyTop - h * 0.005, const Radius.circular(2)),
        Paint()..color = _blackHi);
  }

  void _latch(Canvas canvas, double w, double h, double cx, double seamY) {
    final black = Paint()..color = _black;
    final dk = Paint()..color = _blackDk;
    final hi = Paint()..color = _blackHi;
    // correa que monta sobre la tapa (arriba)
    canvas.drawRRect(RRect.fromLTRBR(cx - w * 0.032, seamY - h * 0.075, cx + w * 0.032, seamY + h * 0.01, const Radius.circular(4)), black);
    // placa base sobre el cuerpo (abajo, más ancha — trapecio sutil)
    final plate = Path()
      ..moveTo(cx - w * 0.045, seamY + h * 0.005)
      ..lineTo(cx + w * 0.045, seamY + h * 0.005)
      ..lineTo(cx + w * 0.038, seamY + h * 0.11)
      ..lineTo(cx - w * 0.038, seamY + h * 0.11)
      ..close();
    canvas.drawPath(plate, black);
    // hebilla (línea) + sombra
    canvas.drawRRect(RRect.fromLTRBR(cx - w * 0.045, seamY + h * 0.035, cx + w * 0.045, seamY + h * 0.05, const Radius.circular(2)), dk);
    canvas.drawRRect(RRect.fromLTRBR(cx - w * 0.045, seamY + h * 0.035, cx + w * 0.045, seamY + h * 0.042, const Radius.circular(2)), hi);
    // pivote
    canvas.drawCircle(Offset(cx, seamY + h * 0.075), w * 0.011, hi);
  }

  @override
  bool shouldRepaint(covariant _ToolboxPainter old) => old.lid != lid;
}
