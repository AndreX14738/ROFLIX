import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Centro de Ayuda',
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
          _buildSearchBar(),
          const SizedBox(height: 30),
          _buildSectionTitle('Preguntas Frecuentes'),
          _buildHelpItem(
            '¿Cómo puedo cambiar mi plan?',
            'Información sobre cómo actualizar o cambiar tu suscripción',
            Icons.credit_card,
          ),
          _buildHelpItem(
            '¿Cómo descargar contenido?',
            'Pasos para descargar películas y series',
            Icons.download,
          ),
          _buildHelpItem(
            '¿Problemas de reproducción?',
            'Soluciones para problemas de video',
            Icons.play_circle_outline,
          ),
          _buildHelpItem(
            '¿Cómo gestionar perfiles?',
            'Crear, editar y eliminar perfiles',
            Icons.people,
          ),
          const SizedBox(height: 30),
          _buildSectionTitle('Contacto'),
          _buildContactItem(
            'Chat en vivo',
            'Habla con nuestro equipo de soporte',
            Icons.chat,
            '24/7 disponible',
          ),
          _buildContactItem(
            'Email',
            'Envía un email a soporte',
            Icons.email,
            'soporte@roflix.com',
          ),
          _buildContactItem(
            'Teléfono',
            'Llama a nuestro centro de atención',
            Icons.phone,
            '+1 800 123 4567',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF333333),
        ),
      ),
      child: TextField(
        style: GoogleFonts.inter(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar en el centro de ayuda...',
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFFB3B3B3),
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFFB3B3B3),
          ),
        ),
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

  Widget _buildHelpItem(String title, String subtitle, IconData icon) {
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
          color: const Color(0xFFE50914),
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
          // Aquí se podría navegar a la página de ayuda específica
        },
      ),
    );
  }

  Widget _buildContactItem(
    String title,
    String subtitle,
    IconData icon,
    String info,
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
          color: const Color(0xFFE50914),
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFFB3B3B3),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              info,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFFE50914),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        onTap: () {
          // Aquí se podría abrir el chat, email o teléfono
        },
      ),
    );
  }
}
