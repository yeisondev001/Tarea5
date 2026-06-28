import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';
import '../widgets/anim.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  Future<void> _predict() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() { _loading = true; _result = null; _error = null; });
    try {
      final res = await http.get(Uri.parse('https://api.genderize.io/?name=$name'));
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

  @override
  Widget build(BuildContext context) {
    final isMale = _result?['gender'] == 'male';
    final accentColor = _result == null
        ? AppColors.primary
        : (isMale ? const Color(0xFF8DCDFD) : const Color(0xFFFFB4D4));

    return Scaffold(
      appBar: AppBar(title: const Text('Predecir Género')),
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
                hintText: 'ej. Maria, Carlos...',
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
                label: Text(_loading ? 'Analizando...' : 'Predecir género'),
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
            if (_result != null) ...[
              const SizedBox(height: 24),
              PopIn(
                child: AppCard(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor.withOpacity(0.3), width: 0.5),
                      ),
                      child: Icon(isMale ? Icons.male : Icons.female, size: 56, color: accentColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _result!['name'] ?? '',
                      style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 8),
                    AppChip(isMale ? 'Masculino' : 'Femenino', color: accentColor),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Stat('Muestra', '${_result!['count']} nombres'),
                      ],
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

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 20)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11, letterSpacing: 0.05)),
      ],
    );
  }
}
