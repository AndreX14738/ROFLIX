import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cast.dart';

class CastCard extends StatelessWidget {
  final Cast cast;

  const CastCard({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto del actor
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 80,
              width: double.infinity,
              child: cast.fullProfileUrl.isNotEmpty
                  ? Image.network(
                      cast.fullProfileUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFF1A1A1A),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFE50914),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white38,
                          size: 32,
                        ),
                      ),
                    )
                  : Container(
                      color: const Color(0xFF1A1A1A),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white38,
                        size: 32,
                      ),
                    ),
            ),
          ),

          // Información del actor
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nombre del actor
                  Text(
                    cast.name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Personaje
                  Text(
                    cast.character,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white60,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
