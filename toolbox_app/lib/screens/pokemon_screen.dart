import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import '../theme/app_theme.dart';

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
            const Icon(Icons.catching_pokemon, size: 48, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(_error!, style: GoogleFonts.inter(color: AppColors.error)),
          ]))),
          if (_pokemon != null) Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (imageUrl != null)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 0.5),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Image.network(imageUrl, height: 140, fit: BoxFit.contain),
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
                  const SizedBox(height: 12),
                  AppCard(
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
                  const SizedBox(height: 12),
                  if (abilities != null) AppCard(
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _playing ? null : _playSound,
                      icon: Icon(_playing ? Icons.volume_up : Icons.play_circle_outline),
                      label: Text(_playing ? 'Reproduciendo...' : 'Escuchar sonido'),
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
