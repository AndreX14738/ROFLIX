import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  const ProfileScreen({super.key, required this.userName, required this.userEmail});

  // Lista demo de películas favoritas (igual que en home)
  static const List<Map<String, dynamic>> demoMovies = [
    {
      'title': 'Inception',
      'poster_path': '/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
    },
    {
      'title': 'Interstellar',
      'poster_path': '/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
    },
    {
      'title': 'The Dark Knight',
      'poster_path': '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    },
    {
      'title': 'Avengers: Endgame',
      'poster_path': '/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
    },
    {
      'title': 'Spider-Man: No Way Home',
      'poster_path': '/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
    },
    {
      'title': 'Joker',
      'poster_path': '/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
    },
    {
      'title': 'Black Panther',
      'poster_path': '/uxzzxijgPIY7slzFvMotPv8wjKA.jpg',
    },
    {
      'title': 'Frozen II',
      'poster_path': '/pjeMs3yqRmFL3giJy4PMXWZTTPa.jpg',
    },
    {
      'title': 'Toy Story 4',
      'poster_path': '/w9kR8qbmQ01HwnvK4alvnQ2ca0L.jpg',
    },
    {
      'title': 'Parasite',
      'poster_path': '/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Mi Perfil', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                ),
                const SizedBox(height: 16),
                Text(userName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(userEmail, style: const TextStyle(color: Colors.white54, fontSize: 15)),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Mis Favoritos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: demoMovies.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final item = demoMovies[index];
                      return Container(
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: item['poster_path'] != null
                                  ? Image.network(
                                      'https://image.tmdb.org/t/p/w500${item['poster_path']}',
                                      height: 110,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(height: 110, color: Colors.grey[800]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Text(
                                item['title'] ?? '',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
