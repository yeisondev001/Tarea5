import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';
import '../widgets/anim.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  Future<void> _predict() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() { _loading = true; _result = null; _error = null; });
    try {
      final res = await http.get(Uri.parse('https://api.agify.io/?name=$name'));
      if (res.statusCode == 200) {
        setState(() { _result = jsonDecode(res.body); });
      } else {
        setState(() { _error = 'Error al consultar la API'; });
      }
    } catch (_) {
      setState(() { _error = 'Error de conexión'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  String _category(int age) => age < 30 ? 'Joven' : age < 60 ? 'Adulto' : 'Anciano';
  IconData _icon(int age)    => age < 30 ? Icons.directions_run : age < 60 ? Icons.work_outline : Icons.elderly;
  Color    _color(int age)   => age < 30 ? const Color(0xFF4ADE80) : age < 60 ? const Color(0xFF8DCDFD) : AppColors.primary;
  String   _imgUrl(int age)  => age < 30
      ? 'https://img.icons8.com/color/200/teenager-boy.png'
      : age < 60
          ? 'https://img.icons8.com/color/200/businessman.png'
          : 'https://img.icons8.com/color/200/old-man.png';

  @override
  Widget build(BuildContext context) {
    final age = _result?['age'] as int?;

    return Scaffold(
      appBar: AppBar(title: const Text('Predecir Edad')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre', style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.05)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              style: GoogleFonts.inter(color: AppColors.onSurface),
              decoration: const InputDecoration(
                hintText: 'ej. Pedro, Ana...',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.onSurfaceVariant),
              ),
              onSubmitted: (_) => _predict(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _predict,
                icon: _loading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                    : const Icon(Icons.search),
                label: Text(_loading ? 'Analizando...' : 'Predecir edad'),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              AppCard(child: Row(children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                const SizedBox(width: 8),
                Text(_error!, style: GoogleFonts.inter(color: AppColors.error)),
              ])),
            ],
            if (_result != null && age != null) ...[
              const SizedBox(height: 24),
              PopIn(
                child: AppCard(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Floating(
                      amplitude: 6,
                      child: Image.network(_imgUrl(age), height: 110,
                        errorBuilder: (_, __, ___) => Icon(_icon(age), size: 80, color: _color(age))),
                    ),
                    const SizedBox(height: 16),
                    Text(_result!['name'] ?? '',
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                    const SizedBox(height: 4),
                    CountUp(
                      value: age,
                      suffix: ' años',
                      style: GoogleFonts.inter(fontSize: 52, fontWeight: FontWeight.w800, color: _color(age)),
                    ),
                    const SizedBox(height: 8),
                    AppChip(_category(age), color: _color(age)),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(
                      age < 30
                          ? 'Lleno de energía y oportunidades'
                          : age < 60
                              ? 'Etapa de experiencia y madurez'
                              : 'Sabiduría acumulada con los años',
                      style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
