import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Configuración',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('Cuenta'),
          _buildSettingItem(
            context,
            Icons.person_outline,
            'Gestionar perfiles',
            'Agregar, editar o eliminar perfiles',
          ),
          _buildSettingItem(
            context,
            Icons.email_outlined,
            'Cambiar email',
            'Actualizar tu dirección de correo',
          ),
          _buildSettingItem(
            context,
            Icons.lock_outline,
            'Cambiar contraseña',
            'Modificar tu contraseña actual',
          ),
          const SizedBox(height: 30),
          _buildSectionTitle('Reproducción'),
          _buildSettingItem(
            context,
            Icons.hd,
            'Calidad de video',
            'Configurar calidad de reproducción',
          ),
          _buildSettingItem(
            context,
            Icons.subtitles_outlined,
            'Subtítulos y audio',
            'Idioma y configuración de subtítulos',
          ),
          _buildSettingItem(
            context,
            Icons.download_outlined,
            'Descargas',
            'Configurar descargas offline',
          ),
          const SizedBox(height: 30),
          _buildSectionTitle('Privacidad'),
          _buildSettingItem(
            context,
            Icons.visibility_outlined,
            'Historial de visualización',
            'Ver y gestionar tu historial',
          ),
          _buildSettingItem(
            context,
            Icons.notifications_outlined,
            'Notificaciones',
            'Configurar alertas y notificaciones',
          ),
          const SizedBox(height: 30),
          _buildSectionTitle('Soporte'),
          _buildSettingItem(
            context,
            Icons.help_outline,
            'Centro de ayuda',
            'Obtener ayuda y soporte',
          ),
          _buildSettingItem(
            context,
            Icons.info_outline,
            'Acerca de',
            'Información de la aplicación',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFFB3B3B3),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFB3B3B3),
          size: 16,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Configurando: $title'),
              backgroundColor: const Color(0xFFE50914),
            ),
          );
        },
      ),
    );
  }
}
