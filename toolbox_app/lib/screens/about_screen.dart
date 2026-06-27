import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _name     = 'Tu Nombre Completo';
  static const String _matricula= '2X-XXXX';
  static const String _email    = 'tuemail@ejemplo.com';
  static const String _phone    = '+1 (809) XXX-XXXX';
  static const String _github   = 'https://github.com/tuusuario';
  static const String _linkedin = 'https://linkedin.com/in/tuusuario';
  static const String _photoUrl = 'https://via.placeholder.com/200x200.png?text=Foto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: AppColors.surfaceHighest,
                    backgroundImage: NetworkImage(_photoUrl),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
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
            const SizedBox(height: 16),
            Text(_name, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            const SizedBox(height: 4),
            AppChip('Matrícula: $_matricula'),
            const SizedBox(height: 24),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CONTACTO', style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.05)),
                  const SizedBox(height: 16),
                  _ContactItem(Icons.email_outlined,  'Email',    _email,    'mailto:$_email'),
                  const Divider(),
                  _ContactItem(Icons.phone_outlined,  'Teléfono', _phone,    'tel:$_phone'),
                  const Divider(),
                  _ContactItem(Icons.code,            'GitHub',   _github,   _github),
                  const Divider(),
                  _ContactItem(Icons.work_outline,    'LinkedIn', _linkedin, _linkedin),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SOBRE MÍ', style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.05)),
                  const SizedBox(height: 12),
                  Text(
                    'Estudiante de desarrollo de aplicaciones móviles, apasionado por la tecnología y el software. '
                    'Disponible para oportunidades laborales y proyectos freelance.',
                    style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 14, height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flutter_dash, color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Text('Hecho con Flutter • Tarea 6', style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;
  const _ContactItem(this.icon, this.label, this.value, this.url);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11)),
                Text(value, style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: AppColors.outline, size: 18),
          ],
        ),
      ),
    );
  }
}
