import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';
import '../widgets/anim.dart';
import '../widgets/appear.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _loading = true;
  Map<String, dynamic>? _data;
  String? _error;

  static const double _lat = 18.4861;
  static const double _lon = -69.9312;

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$_lat&longitude=$_lon'
        '&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code'
        '&daily=temperature_2m_max,temperature_2m_min,weather_code'
        '&timezone=America%2FSanto_Domingo&forecast_days=3',
      );
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        setState(() { _data = jsonDecode(res.body); });
      } else {
        setState(() { _error = 'Error al obtener el clima'; });
      }
    } catch (_) {
      setState(() { _error = 'Error de conexión'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  void initState() { super.initState(); _load(); }

  String _desc(int c) {
    if (c == 0) return 'Despejado';
    if (c <= 3) return 'Parcialmente nublado';
    if (c <= 48) return 'Neblina';
    if (c <= 67) return 'Lluvia';
    if (c <= 77) return 'Nieve';
    if (c <= 82) return 'Chubascos';
    return 'Tormenta';
  }

  IconData _icon(int c) {
    if (c == 0) return Icons.wb_sunny_outlined;
    if (c <= 3) return Icons.cloud_outlined;
    if (c <= 48) return Icons.foggy;
    if (c <= 67) return Icons.umbrella;
    if (c <= 82) return Icons.grain;
    return Icons.thunderstorm_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final current = _data?['current'] as Map?;
    final daily   = _data?['daily']   as Map?;
    final wcode   = (current?['weather_code'] as num?)?.toInt() ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Clima en RD')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 12),
                  Text(_error!, style: GoogleFonts.inter(color: AppColors.error)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _load, child: const Text('Reintentar')),
                ]))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 16),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text('Santo Domingo, República Dominicana',
                                    style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Floating(child: Icon(_icon(wcode), size: 64, color: AppColors.primary)),
                            const SizedBox(height: 12),
                            CountUp(
                              value: (current?['temperature_2m'] as num?) ?? 0,
                              decimals: 1,
                              suffix: '°C',
                              style: GoogleFonts.inter(fontSize: 56, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                            ),
                            const SizedBox(height: 4),
                            Text(_desc(wcode),
                              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 16)),
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _InfoTile(Icons.water_drop_outlined, '${current?['relative_humidity_2m']}%', 'Humedad'),
                                _InfoTile(Icons.air, '${current?['wind_speed_10m']} km/h', 'Viento'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Próximos días', style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.05)),
                      const SizedBox(height: 12),
                      if (daily != null) ...List.generate(
                        (daily['time'] as List).length,
                        (i) {
                          final code = (daily['weather_code'] as List)[i] as int;
                          final max  = daily['temperature_2m_max'][i];
                          final min  = daily['temperature_2m_min'][i];
                          final date = daily['time'][i] as String;
                          return Appear(
                            index: i,
                            child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: AppCard(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  Icon(_icon(code), color: AppColors.primary, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(date, style: GoogleFonts.inter(color: AppColors.onSurface, fontWeight: FontWeight.w500, fontSize: 13)),
                                      Text(_desc(code), style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11)),
                                    ]),
                                  ),
                                  Text('$min° / $max°',
                                    style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _InfoTile(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
      const SizedBox(height: 4),
      Text(value, style: GoogleFonts.inter(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
      Text(label, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11)),
    ]);
  }
}
