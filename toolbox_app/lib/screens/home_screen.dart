import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
import '../theme/app_theme.dart';
import '../widgets/toolbox.dart';
import '../widgets/screen_preview.dart';
import '../widgets/garage_background.dart';
import 'gender_screen.dart';
import 'age_screen.dart';
import 'universities_screen.dart';
import 'weather_screen.dart';
import 'pokemon_screen.dart';
import 'wordpress_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _fall;
  late final AnimationController _open;
  late final AnimationController _belt;
  late final AnimationController _dock;
  late final AnimationController _snap;
  late final Animation<double> _fallAnim;
  late final Animation<double> _lidAnim;

  bool _landed = false;
  bool _firstOpened = false;
  bool _fanWantOpen = false;

  static const double _stepAngle = 0.24;
  static const double _pivotRadius = 320;
  static const double _dragUnit = 60;

  double _focus = -10; // -10 = ninguna resaltada al inicio
  int _selected = -1;  // -1 = ninguna seleccionada
  double _snapFrom = 0, _snapTo = 0;

  int get _n => _tools.length;
  double get _mid => (_n - 1) / 2;

  @override
  void initState() {
    super.initState();
    _fall = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fallAnim = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _fall, curve: Curves.bounceOut));
    _open = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _lidAnim = CurvedAnimation(parent: _open, curve: Curves.easeOutBack);
    _belt = AnimationController(vsync: this, duration: const Duration(milliseconds: 950));
    _dock = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _snap = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {
          _focus = lerpDouble(_snapFrom, _snapTo, Curves.easeOut.transform(_snap.value))!;
        });
      });

    _fall.addStatusListener((s) {
      if (s == AnimationStatus.completed) setState(() => _landed = true);
    });
    _open.addStatusListener((s) {
      if (s == AnimationStatus.completed && _fanWantOpen) {
        _belt.forward();
        if (_dock.status == AnimationStatus.dismissed) _dock.forward();
      }
    });
    _belt.addStatusListener((s) {
      if (s == AnimationStatus.dismissed && !_fanWantOpen) _open.reverse();
    });

    _fall.forward();
  }

  @override
  void dispose() {
    _fall.dispose();
    _open.dispose();
    _belt.dispose();
    _dock.dispose();
    _snap.dispose();
    super.dispose();
  }

  void _toggleFan() {
    if (!_landed) return;
    if (!_firstOpened) {
      setState(() {
        _firstOpened = true;
        _fanWantOpen = true;
      });
      _open.forward();
      return;
    }
    if (_fanWantOpen) {
      setState(() => _fanWantOpen = false);
      _belt.reverse();
    } else {
      setState(() => _fanWantOpen = true);
      _open.forward();
    }
  }

  void _snapToIndex(int i) {
    _snapFrom = _focus;
    _snapTo = i.clamp(0, _n - 1).toDouble();
    _snap.forward(from: 0);
  }

  void _onDragUpdate(DragUpdateDetails d) {
    _snap.stop();
    setState(() {
      _focus = (_focus - (d.primaryDelta ?? 0) / _dragUnit).clamp(0.0, (_n - 1).toDouble());
    });
  }

  void _onDragEnd(DragEndDetails d) {
    final vx = d.velocity.pixelsPerSecond.dx;
    final fling = (vx.abs() > 400) ? (vx < 0 ? 1 : -1) : 0;
    _snapToIndex((_focus.round() + fling).clamp(0, _n - 1));
  }

  List<_Tool> get _tools => const [
        _Tool(Icons.face_outlined, 'Predecir Género', 'Género por nombre', GenderScreen()),
        _Tool(Icons.cake_outlined, 'Predecir Edad', 'Edad por nombre', AgeScreen()),
        _Tool(Icons.school_outlined, 'Universidades', 'Por país', UniversitiesScreen()),
        _Tool(Icons.cloud_outlined, 'Clima en RD', 'Pronóstico', WeatherScreen()),
        _Tool(Icons.catching_pokemon, 'Pokémon', 'Info y stats', PokemonScreen()),
        _Tool(Icons.article_outlined, 'WordPress', 'Últimas noticias', WordpressScreen()),
        _Tool(Icons.person_outlined, 'Acerca de', 'Contacto', AboutScreen()),
      ];

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final boxBottom = screenH * 0.26 - 20; // base de la caja sobre la mesa (~74%)

    return Scaffold(
      body: Stack(
        children: [
          const RepaintBoundary(child: GarageBackground()),

          // ABANICO (sobre la mesa) — solo cuando ya se abrió alguna vez
          if (_firstOpened)
            Positioned(
              top: MediaQuery.of(context).padding.top + 56,
              left: 0,
              right: 0,
              bottom: screenH * 0.40,
              child: GestureDetector(
                // arrastre opcional para hojear; el TOQUE en cada carta tiene prioridad
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: _buildFan(),
              ),
            ),

          // Encabezado
          if (_firstOpened)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 18,
              right: 18,
              child: Row(
                children: [
                  // badge con ícono de herramientas
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFE9A0), AppColors.primaryContainer],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: const Icon(Icons.handyman, color: Color(0xFF3B2F00), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Caja de Herramientas',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 21,
                            color: Colors.white,
                            height: 1.05,
                            letterSpacing: -0.3,
                            shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 6, offset: const Offset(0, 1))],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.32),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColors.primary.withOpacity(0.35), width: 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.touch_app_outlined, color: AppColors.primary, size: 12),
                              const SizedBox(width: 5),
                              Text(
                                'Toca para elegir · otra vez para abrir',
                                style: GoogleFonts.inter(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.02),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Sugerencia (antes del primer open)
          if (!_firstOpened)
            Positioned(
              bottom: screenH * 0.12,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _landed ? 1 : 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 0.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.touch_app_outlined, color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Text('Toca la caja para abrir',
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.02)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // LA CAJA: cae sobre la mesa y se abre/cierra al tocar
          Positioned(
            bottom: boxBottom,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _toggleFan,
                child: AnimatedBuilder(
                  animation: Listenable.merge([_fall, _open]),
                  builder: (context, _) {
                    final dy = _fallAnim.value * screenH * 0.78;
                    // tamaño CONSTANTE (no encoge al abrir/cerrar)
                    return Transform.translate(
                      offset: Offset(0, -dy),
                      child: Toolbox(size: 168, lidProgress: _lidAnim.value),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Lienzo del abanico (las cartas se colocan con coordenadas exactas dentro,
  // así ninguna se sale del área que recibe el toque).
  static const double _fanW = 740;
  static const double _fanH = 390;
  static const double _fanCX = 370;
  static const double _fanCY = 475; // centro del arco (debajo)
  static const double _cardW = 168;
  static const double _cardH = 240;

  Widget _buildFan() {
    return AnimatedBuilder(
      animation: _belt,
      builder: (context, _) {
        final b = Curves.easeOut.transform(_belt.value);
        return Transform.translate(
          offset: Offset(0, (1 - b) * 90),
          child: Transform.scale(
            scale: lerpDouble(0.45, 1.0, b)!,
            alignment: Alignment.bottomCenter,
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: _fanW,
                  height: _fanH,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: (List.generate(_n, (i) => i)
                          ..sort((a, c) => (c - _focus).abs().compareTo((a - _focus).abs())))
                        .map(_buildCard)
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(int i) {
    final t = Interval((i * 0.05).clamp(0.0, 1.0), (i * 0.05 + 0.5).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic)
        .transform(_belt.value);
    final angle = (i - _mid) * _stepAngle * t; // arco simétrico que se despliega
    final d = i - _focus;
    final prox = (1 - d.abs()).clamp(0.0, 1.0);
    final selected = _selected == i;
    final emph = selected ? 1.0 : prox; // énfasis visual
    final scale = lerpDouble(0.96, 1.12, emph)! * lerpDouble(0.7, 1.0, t)!;
    final lift = emph * 26.0;
    final dim = lerpDouble(0.94, 1.0, emph)!; // las no seleccionadas casi no se atenúan

    // posición exacta de la carta sobre el arco
    final cx = _fanCX + _pivotRadius * math.sin(angle);
    final cy = _fanCY - _pivotRadius * math.cos(angle) - lift;

    return Positioned(
      left: cx - _cardW / 2,
      top: cy - _cardH / 2,
      width: _cardW,
      height: _cardH,
      child: Opacity(
        opacity: t * dim,
        child: Transform.rotate(
          angle: angle,
          child: Transform.scale(
            scale: scale,
            child: _FanCard(
              tool: _tools[i],
              focused: selected,
              onTap: (open) => _tapCard(i, open),
            ),
          ),
        ),
      ),
    );
  }

  // 1er toque: selecciona (la trae al frente). 2º toque en la seleccionada: abre.
  void _tapCard(int i, VoidCallback open) {
    if (_selected == i) {
      open();
      return;
    }
    final first = _selected < 0;
    setState(() => _selected = i);
    if (first) {
      setState(() => _focus = i.toDouble());
    } else {
      _snapToIndex(i);
    }
  }
}

class _Tool {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget screen;
  const _Tool(this.icon, this.title, this.subtitle, this.screen);
}

class _FanCard extends StatelessWidget {
  final _Tool tool;
  final bool focused;
  final void Function(VoidCallback open) onTap;
  const _FanCard({required this.tool, required this.focused, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      height: 240,
      child: OpenContainer(
        tappable: false, // el toque lo controla nuestra lógica (seleccionar/abrir)
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 480),
        closedElevation: focused ? 12 : 4,
        openElevation: 0,
        closedColor: AppColors.surfaceHigh,
        openColor: AppColors.background,
        middleColor: AppColors.background,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: focused ? AppColors.primary.withOpacity(0.7) : AppColors.outline,
            width: focused ? 1.6 : 0.8,
          ),
        ),
        openBuilder: (context, _) => tool.screen,
        closedBuilder: (context, open) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(open),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ScreenPreview(icon: tool.icon, title: tool.title),
                  ),
                ),
                const SizedBox(height: 8),
                // título a todo el ancho → cabe el nombre completo y se lee bien
                Text(
                  tool.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.5, height: 1.05),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
