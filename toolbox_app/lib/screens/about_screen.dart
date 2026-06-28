import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  static const String _name = 'Yeison Gregori Rojas Henríquez';
  static const String _matricula = '20241822';
  static const String _email = 'yeisonrojass03@gmail.com';
  static const String _phone = '+1 (829) 801-9374';
  static const String _github = 'https://github.com/yeisondev001';
  static const String _linkedin = 'https://www.linkedin.com/in/yeison-rojas-henriquez';
  static const String _photoAsset = 'assets/images/yeison.jpg';

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late final AnimationController _entrance; // entrada coreografiada (una vez)
  late final AnimationController _ring;     // anillo dorado girando (loop)

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..forward();
    _ring = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _ring.dispose();
    super.dispose();
  }

  /// Revela [child] con fade + slide-up, escalonado según [i].
  Widget _reveal(int i, Widget child) {
    final start = (0.12 + i * 0.12).clamp(0.0, 0.85);
    return AnimatedBuilder(
      animation: _entrance,
      builder: (context, c) {
        final t = Interval(start, (start + 0.45).clamp(0.0, 1.0), curve: Curves.easeOutCubic)
            .transform(_entrance.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, (1 - t) * 16), child: c),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _avatar(),
            const SizedBox(height: 16),
            _reveal(1, Text(AboutScreen._name,
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.onSurface))),
            const SizedBox(height: 4),
            _reveal(2, AppChip('Matrícula: ${AboutScreen._matricula}')),
            const SizedBox(height: 24),
            _reveal(3, _contactCard()),
            const SizedBox(height: 12),
            _reveal(4, _aboutCard()),
            const SizedBox(height: 12),
            _reveal(5, _footer()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ---------- AVATAR con anillo girando + pop de entrada ----------
  Widget _avatar() {
    return AnimatedBuilder(
      animation: _entrance,
      builder: (context, child) {
        // pop con leve overshoot (easeOutBack puede pasar de 1.0)
        final t = Interval(0.0, 0.5, curve: Curves.easeOutBack).transform(_entrance.value);
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.scale(scale: lerpDouble(0.9, 1.0, t)!, child: child),
        );
      },
      child: Center(
        child: SizedBox(
          width: 132,
          height: 132,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // anillo de gradiente dorado girando
              AnimatedBuilder(
                animation: _ring,
                builder: (context, _) => Transform.rotate(
                  angle: _ring.value * 2 * math.pi,
                  child: Container(
                    width: 132,
                    height: 132,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          AppColors.primary,
                          Colors.transparent,
                          AppColors.primaryContainer,
                          Colors.transparent,
                          AppColors.primary,
                        ],
                        stops: [0.0, 0.28, 0.5, 0.72, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              // máscara interior (deja el anillo fino)
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.background),
              ),
              // foto
              ClipOval(
                child: SizedBox(
                  width: 112,
                  height: 112,
                  child: Image.asset(
                    AboutScreen._photoAsset,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.6),
                  ),
                ),
              ),
              // badge de verificado
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(Icons.check, color: AppColors.onPrimary, size: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONTACTO',
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.05)),
          const SizedBox(height: 12),
          _ContactItem(Icons.email_outlined, 'Email', AboutScreen._email, 'mailto:${AboutScreen._email}'),
          const Divider(),
          _ContactItem(Icons.phone_outlined, 'Teléfono', AboutScreen._phone, 'tel:${AboutScreen._phone}'),
          const Divider(),
          _ContactItem(Icons.code, 'GitHub', 'github.com/yeisondev001', AboutScreen._github),
          const Divider(),
          _ContactItem(Icons.work_outline, 'LinkedIn', 'yeison-rojas-henriquez', AboutScreen._linkedin),
        ],
      ),
    );
  }

  Widget _aboutCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SOBRE MÍ',
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.05)),
          const SizedBox(height: 12),
          Text(
            'Estudiante de desarrollo de aplicaciones móviles, apasionado por la tecnología y el software. '
            'Disponible para oportunidades laborales y proyectos freelance.',
            style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flutter_dash, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Text('Hecho con Flutter • Tarea 6',
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 12)),
        ],
      ),
    );
  }
}

/// Fila de contacto con microinteracción: al tocar se ilumina y el chevron se desliza.
class _ContactItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;
  const _ContactItem(this.icon, this.label, this.value, this.url);

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _pressed = false;

  void _set(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapCancel: () => _set(false),
      onTapUp: (_) {
        _set(false);
        launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.primary.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11)),
                Text(widget.value, style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            const Spacer(),
            AnimatedSlide(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              offset: _pressed ? const Offset(0.25, 0) : Offset.zero,
              child: Icon(Icons.chevron_right,
                  color: _pressed ? AppColors.primary : AppColors.outline, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
