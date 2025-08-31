import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Acerca de ROFLIX',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo de la app
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE50914),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'ROFLIX',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Información de la versión
            Text(
              'ROFLIX',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Versión 1.0.0',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFFB3B3B3),
              ),
            ),
            const SizedBox(height: 30),
            
            // Descripción
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Tu plataforma de streaming favorita',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ROFLIX te ofrece una experiencia de entretenimiento incomparable con miles de películas, series y documentales. Disfruta de contenido en alta calidad cuando quieras y donde quieras.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFFB3B3B3),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Información técnica
            _buildInfoSection('Desarrollado por', 'Equipo ROFLIX'),
            _buildInfoSection('Última actualización', '24 de agosto de 2025'),
            _buildInfoSection('Compatibilidad', 'Android, iOS, Web'),
            _buildInfoSection('Tamaño', '25.6 MB'),
            
            const SizedBox(height: 30),
            
            // Enlaces
            _buildLinkSection(),
            
            const SizedBox(height: 30),
            
            // Copyright
            Text(
              '© 2025 ROFLIX. Todos los derechos reservados.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF888888),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF333333),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFFB3B3B3),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Enlaces',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildLinkItem('Términos de Servicio', Icons.description),
          _buildLinkItem('Política de Privacidad', Icons.security),
          _buildLinkItem('Licencias de Código Abierto', Icons.code),
          _buildLinkItem('Calificar la App', Icons.star),
        ],
      ),
    );
  }

  Widget _buildLinkItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          icon,
          color: const Color(0xFFE50914),
          size: 20,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFFE50914),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFB3B3B3),
          size: 14,
        ),
        onTap: () {
          // Aquí se abriría el enlace correspondiente
        },
      ),
    );
  }
}
