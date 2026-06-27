import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'gender_screen.dart';
import 'age_screen.dart';
import 'universities_screen.dart';
import 'weather_screen.dart';
import 'pokemon_screen.dart';
import 'wordpress_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      _Tool(Icons.face_outlined,      'Predecir Género',     'Descubre el género por nombre',   () => Navigator.push(context, _route(const GenderScreen()))),
      _Tool(Icons.cake_outlined,      'Predecir Edad',       'Estima la edad por nombre',        () => Navigator.push(context, _route(const AgeScreen()))),
      _Tool(Icons.school_outlined,    'Universidades',       'Busca universidades por país',     () => Navigator.push(context, _route(const UniversitiesScreen()))),
      _Tool(Icons.cloud_outlined,     'Clima en RD',         'Temperatura y pronóstico',         () => Navigator.push(context, _route(const WeatherScreen()))),
      _Tool(Icons.catching_pokemon,   'Pokémon',             'Info, stats y sonido',             () => Navigator.push(context, _route(const PokemonScreen()))),
      _Tool(Icons.article_outlined,   'Noticias WordPress',  'Últimas 3 noticias del blog',      () => Navigator.push(context, _route(const WordpressScreen()))),
      _Tool(Icons.person_outlined,    'Acerca de',           'Datos de contacto',                () => Navigator.push(context, _route(const AboutScreen()))),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.surfaceContainer,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Caja de Herramientas', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.onSurface)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1E2020), Color(0xFF121414)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 0.5),
                      ),
                      child: const Icon(Icons.build_outlined, size: 48, color: AppColors.primary),
                    ),
                    const SizedBox(height: 12),
                    Text('${tools.length} herramientas disponibles',
                      style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 12, letterSpacing: 0.05)),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ToolCard(tool: tools[i]),
                childCount: tools.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  PageRoute _route(Widget page) => PageRouteBuilder(
    pageBuilder: (_, a, __) => page,
    transitionsBuilder: (_, a, __, child) => FadeTransition(
      opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
            .animate(CurvedAnimation(parent: a, curve: Curves.easeOut)),
        child: child,
      ),
    ),
    transitionDuration: const Duration(milliseconds: 220),
  );
}

class _Tool {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _Tool(this.icon, this.title, this.subtitle, this.onTap);
}

class _ToolCard extends StatefulWidget {
  final _Tool tool;
  const _ToolCard({required this.tool});

  @override
  State<_ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<_ToolCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.tool.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _pressed ? AppColors.surfaceHighest : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pressed ? AppColors.primary.withOpacity(0.4) : AppColors.outlineVariant,
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.tool.icon, color: AppColors.primary, size: 24),
            ),
            const Spacer(),
            Text(widget.tool.title,
              style: GoogleFonts.inter(color: AppColors.onSurface, fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 4),
            Text(widget.tool.subtitle,
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
