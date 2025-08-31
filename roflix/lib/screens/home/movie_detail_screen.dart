import 'package:flutter/material.dart';
import '../../services/favorites_service.dart';

class MovieDetailScreen extends StatelessWidget {
  final Map<String, dynamic> movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: movie['poster'],
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                child: Image.network(
                  movie['poster'],
                  height: 320,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(height: 320, color: Colors.grey[900]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        movie['rating'].toString(),
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    movie['synopsis'] ?? 'Sinopsis no disponible.',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await FavoritesService.addFavorite(movie);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agregado a favoritos')),
                      );
                    },
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Agregar a Favoritos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Aquí puedes agregar el tráiler embebido de YouTube
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
