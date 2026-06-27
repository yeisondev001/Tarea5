import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/appear.dart';

class WordpressScreen extends StatefulWidget {
  const WordpressScreen({super.key});

  @override
  State<WordpressScreen> createState() => _WordpressScreenState();
}

class _WordpressScreenState extends State<WordpressScreen> {
  bool _loading = true;
  List<dynamic> _posts = [];
  String? _error;

  static const String _siteUrl = 'https://tecnologia21.com';
  static const String _apiUrl  = 'https://tecnologia21.com/wp-json/wp/v2/posts?per_page=3&_embed';

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http.get(Uri.parse(_apiUrl));
      if (res.statusCode == 200) {
        setState(() { _posts = jsonDecode(res.body); });
      } else {
        setState(() { _error = 'Error al cargar las noticias'; });
      }
    } catch (e) {
      setState(() { _error = 'Error de conexión'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  String _stripHtml(String html) => html.replaceAll(RegExp(r'<[^>]*>'), '').trim();

  @override
  void initState() { super.initState(); _load(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias WordPress')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.surfaceContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 0.5),
                  ),
                  child: const Icon(Icons.rss_feed, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('tecnologia21.com', style: GoogleFonts.inter(color: AppColors.onSurface, fontWeight: FontWeight.w600, fontSize: 15)),
                    Text('Blog de tecnología • WordPress', style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11)),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => launchUrl(Uri.parse(_siteUrl), mode: LaunchMode.externalApplication),
                  child: const Icon(Icons.open_in_new, color: AppColors.onSurfaceVariant, size: 18),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (_loading) const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary))),
          if (_error != null) Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 12),
            Text(_error!, style: GoogleFonts.inter(color: AppColors.error)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _load, child: const Text('Reintentar')),
          ]))),
          if (!_loading && _error == null) Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _posts.length,
              itemBuilder: (context, i) {
                final post    = _posts[i];
                final title   = _stripHtml(post['title']?['rendered'] ?? 'Sin título');
                final excerpt = _stripHtml(post['excerpt']?['rendered'] ?? '');
                final link    = post['link'] as String? ?? _siteUrl;
                final featuredMedia = post['_embedded']?['wp:featuredmedia'];
                String? imageUrl;
                if (featuredMedia != null && (featuredMedia as List).isNotEmpty) {
                  final media = featuredMedia[0];
                  if (media != null && media['source_url'] != null) {
                    imageUrl = media['source_url'] as String?;
                  }
                }

                return Appear(
                  index: i,
                  child: AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(height: 60, color: AppColors.surfaceHighest)),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.onSurface)),
                            const SizedBox(height: 8),
                            Text(
                              excerpt.length > 160 ? '${excerpt.substring(0, 160)}...' : excerpt,
                              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.5),
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication),
                              child: Row(children: [
                                const Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text('Visitar artículo', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                              ]),
                            ),
                          ],
                        ),
                      ),
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
