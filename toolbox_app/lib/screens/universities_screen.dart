import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/appear.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final _controller = TextEditingController(text: 'Dominican Republic');
  bool _loading = false;
  List<dynamic> _list = [];
  String? _error;

  Future<void> _search() async {
    final country = _controller.text.trim();
    if (country.isEmpty) return;
    setState(() { _loading = true; _list = []; _error = null; });
    try {
      final encoded = Uri.encodeComponent(country);
      final res = await http.get(Uri.parse('https://adamix.net/proxy.php?country=$encoded'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() { _list = data is List ? data : []; });
      } else {
        setState(() { _error = 'Error al consultar la API'; });
      }
    } catch (e) {
      setState(() { _error = 'Error de conexión'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  void initState() { super.initState(); _search(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.inter(color: AppColors.onSurface),
                    decoration: const InputDecoration(
                      hintText: 'País en inglés...',
                      prefixIcon: Icon(Icons.flag_outlined, color: AppColors.onSurfaceVariant),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _search,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          if (_list.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  AppChip('${_list.length} universidades'),
                ],
              ),
            ),
          const SizedBox(height: 8),
          if (_loading) const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary))),
          if (_error != null) Expanded(
            child: Center(child: AppCard(
              child: Text(_error!, style: GoogleFonts.inter(color: AppColors.error)),
            )),
          ),
          if (!_loading && _error == null) Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _list.length,
              itemBuilder: (context, i) {
                final u = _list[i];
                final domains = (u['domains'] as List?)?.join(', ') ?? '';
                final webPages = u['web_pages'] as List?;
                final url = webPages != null && webPages.isNotEmpty ? webPages[0] as String : null;
                return Appear(
                  index: i < 8 ? i : 0,
                  child: AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u['name'] ?? 'Sin nombre',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.onSurface)),
                      if (domains.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(children: [
                          const Icon(Icons.language, size: 13, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(domains, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 12)),
                        ]),
                      ],
                      if (url != null) ...[
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
                          child: Row(children: [
                            const Icon(Icons.link, size: 13, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(url,
                                style: GoogleFonts.inter(color: AppColors.primary, fontSize: 11, decoration: TextDecoration.underline),
                                overflow: TextOverflow.ellipsis),
                            ),
                          ]),
                        ),
                      ],
                    ],
                  ),
                ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
