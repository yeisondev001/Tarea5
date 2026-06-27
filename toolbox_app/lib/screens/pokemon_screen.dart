import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import '../theme/app_theme.dart';
import '../widgets/anim.dart';
import '../widgets/appear.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _controller = TextEditingController(text: 'pikachu');
  bool _loading = false;
  Map<String, dynamic>? _pokemon;
  String? _error;
  final _player = AudioPlayer();
  bool _playing = false;

  Future<void> _search() async {
    final name = _controller.text.trim().toLowerCase();
    if (name.isEmpty) return;
    setState(() { _loading = true; _pokemon = null; _error = null; });
    try {
      final res = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
      if (res.statusCode == 200) {
        setState(() { _pokemon = jsonDecode(res.body); });
      } else {
        setState(() { _error = 'Pokémon no encontrado'; });
      }
    } catch (_) {
      setState(() { _error = 'Error de conexión'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _playSound() async {
    final url = _pokemon?['cries']?['latest'] as String?;
    if (url == null) return;
    setState(() { _playing = true; });
    await _player.play(UrlSource(url));
    setState(() { _playing = false; });
  }

  @override
  void initState() { super.initState(); _search(); }

  @override
  void dispose() { _player.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final sprites   = _pokemon?['sprites'] as Map?;
    final imageUrl  = sprites?['other']?['official-artwork']?['front_default'] as String?
        ?? sprites?['front_default'] as String?;
    final abilities = (_pokemon?['abilities'] as List?)
        ?.map((a) => a['ability']['name'] as String).toList();
    final types     = (_pokemon?['types'] as List?)
        ?.map((t) => t['type']['name'] as String).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.inter(color: AppColors.onSurface),
                    decoration: const InputDecoration(
                      hintText: 'ej. pikachu, charizard...',
                      prefixIcon: Icon(Icons.catching_pokemon, color: AppColors.onSurfaceVariant),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _search,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          if (_loading) const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary))),
          if (_error != null) Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const PokeballIcon(size: 56),
            const SizedBox(height: 12),
            Text(_error!, style: GoogleFonts.inter(color: AppColors.error)),
          ]))),
          if (_pokemon != null) Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Appear(
                    index: 0,
                    child: AppCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (imageUrl != null)
                          Floating(
                            amplitude: 7,
                            child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 0.5),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Image.network(imageUrl, height: 140, fit: BoxFit.contain),
                          ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          (_pokemon!['name'] as String).toUpperCase(),
                          style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 8),
                        if (types != null) Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: types.map((t) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: AppChip(t),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  ),
                  const SizedBox(height: 12),
                  Appear(
                    index: 1,
                    child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estadísticas', style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.05)),
                        const SizedBox(height: 12),
                        _StatRow('Experiencia base', '${_pokemon!['base_experience']} XP'),
                        _StatRow('Altura', '${(_pokemon!['height'] as int) / 10} m'),
                        _StatRow('Peso',   '${(_pokemon!['weight'] as int) / 10} kg'),
                      ],
                    ),
                  ),
                  ),
                  const SizedBox(height: 12),
                  if (abilities != null) Appear(
                    index: 2,
                    child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Habilidades', style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.05)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: abilities.map((a) => AppChip(a)).toList(),
                        ),
                      ],
                    ),
                  ),
                  ),
                  const SizedBox(height: 16),
                  Appear(
                    index: 3,
                    child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _playing ? null : _playSound,
                      icon: Icon(_playing ? Icons.volume_up : Icons.play_circle_outline),
                      label: Text(_playing ? 'Reproduciendo...' : 'Escuchar sonido'),
                    ),
                  ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pokébola vectorial: mitad superior coloreada (oscura) y mitad inferior blanca.
class PokeballIcon extends StatelessWidget {
  final double size;
  const PokeballIcon({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size, child: CustomPaint(painter: _PokeballPainter()));
  }
}

class _PokeballPainter extends CustomPainter {
  static const _top = Color(0xFFD8362B);    // mitad de arriba (oscura/roja)
  static const _bottom = Color(0xFFECECEC); // mitad de abajo (blanca)
  static const _line = Color(0xFF1A1A1A);   // banda y contornos

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final c = Offset(r, r);

    // mitad inferior blanca (círculo completo de base)
    canvas.drawCircle(c, r, Paint()..color = _bottom);

    // mitad superior coloreada (recortando la parte de arriba)
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, r));
    canvas.drawCircle(c, r, Paint()..color = _top);
    canvas.restore();

    // banda central
    final bandH = r * 0.20;
    canvas.drawRect(Rect.fromLTWH(0, c.dy - bandH / 2, size.width, bandH), Paint()..color = _line);

    // botón central
    canvas.drawCircle(c, r * 0.26, Paint()..color = _line);
    canvas.drawCircle(c, r * 0.18, Paint()..color = _bottom);
    canvas.drawCircle(c, r * 0.10, Paint()..color = _line.withOpacity(0.25)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // contorno
    canvas.drawCircle(c, r - 0.75, Paint()..color = _line..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(covariant _PokeballPainter oldDelegate) => false;
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 13)),
          Text(value, style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
