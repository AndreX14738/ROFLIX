import 'package:flutter/material.dart';
import '../../services/tmdb_service.dart';
import '../../models/movie.dart';
import '../movie_detail/movie_detail_screen.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  List<Map<String, dynamic>> series = [];
  List<Map<String, dynamic>> peliculas = [];
  List<Map<String, dynamic>> sugeridos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => loading = true);
    // Películas demo con imágenes y descripciones reales
    List<Map<String, dynamic>> demoMovies = [
      {
        'id': 1,
        'title': 'Inception',
        'poster_path': '/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
        'overview': 'Un ladrón que roba secretos a través del uso de la tecnología de sueños inversos.',
        'vote_average': 8.8,
        'trailer_key': '8hP9D6kZseM',
      },
      {
        'id': 2,
        'title': 'Interstellar',
        'poster_path': '/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
        'overview': 'Un grupo de exploradores viaja a través de un agujero de gusano en el espacio.',
        'vote_average': 8.6,
        'trailer_key': 'zSWdZVtXT7E',
      },
      {
        'id': 3,
        'title': 'The Dark Knight',
        'poster_path': '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
        'overview': 'Batman se enfrenta al Joker, un criminal anárquico.',
        'vote_average': 9.0,
        'trailer_key': 'EXeTwQWrcwY',
      },
      {
        'id': 4,
        'title': 'Avengers: Endgame',
        'poster_path': '/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
        'overview': 'Los Vengadores se reúnen para revertir las acciones de Thanos.',
        'vote_average': 8.4,
        'trailer_key': 'TcMBFSGVi1c',
      },
      {
        'id': 5,
        'title': 'Spider-Man: No Way Home',
        'poster_path': '/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
        'overview': 'Peter Parker busca la ayuda de Doctor Strange para restaurar su identidad secreta.',
        'vote_average': 8.3,
        'trailer_key': 'JfVOs4VSpmA',
      },
      {
        'id': 6,
        'title': 'Joker',
        'poster_path': '/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
        'overview': 'La historia de Arthur Fleck, un comediante fallido.',
        'vote_average': 8.5,
        'trailer_key': 'zAGVQLHvwOY',
      },
      {
        'id': 7,
        'title': 'Black Panther',
        'poster_path': '/uxzzxijgPIY7slzFvMotPv8wjKA.jpg',
        'overview': 'T’Challa regresa a Wakanda para ser rey.',
        'vote_average': 7.3,
        'trailer_key': 'xjDjIWPwcPU',
      },
      {
        'id': 8,
        'title': 'Frozen II',
        'poster_path': '/pjeMs3yqRmFL3giJy4PMXWZTTPa.jpg',
        'overview': 'Elsa y Anna se embarcan en un viaje peligroso.',
        'vote_average': 7.0,
        'trailer_key': 'Zi4LMpSDccc',
      },
      {
        'id': 9,
        'title': 'Toy Story 4',
        'poster_path': '/w9kR8qbmQ01HwnvK4alvnQ2ca0L.jpg',
        'overview': 'Woody y Buzz Lightyear emprenden una nueva aventura.',
        'vote_average': 7.8,
        'trailer_key': 'wmiIUN-7qhE',
      },
      {
        'id': 10,
        'title': 'Parasite',
        'poster_path': '/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
        'overview': 'Una familia pobre se infiltra en una familia rica.',
        'vote_average': 8.6,
        'trailer_key': '5xH0HfJHsaY',
      },
    ];

    setState(() {
      peliculas = demoMovies;
      series = demoMovies;
      sugeridos = demoMovies;
      loading = false;
    });
  }

  void _goToDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailScreenNew(
          movie: Movie(
            id: item['id'] ?? 0,
            title: item['title'] ?? '',
            overview: item['overview'] ?? '',
            posterPath: item['poster_path'] ?? '',
            backdropPath: item['poster_path'] ?? '',
            voteAverage: (item['vote_average'] ?? 0.0).toDouble(),
            voteCount: 1000,
            releaseDate: '2020-01-01',
            genreIds: [28, 12],
            adult: false,
            originalLanguage: 'es',
            originalTitle: item['title'] ?? '',
            popularity: 100.0,
            video: true,
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () => _goToDetail(item),
                child: Container(
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
                          item['title'] ?? item['name'] ?? '',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 3),
                            Text((item['vote_average']?.toStringAsFixed(1) ?? '-'), style: const TextStyle(color: Colors.white70, fontSize: 12)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'ROFLIX',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text('Inicio', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(width: 18),
                            Text('Series', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(width: 18),
                            Text('Películas', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(Icons.search, color: Colors.white),
                            SizedBox(width: 12),
                            Icon(Icons.notifications_none, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildRow('Series', series),
                  _buildRow('Películas', peliculas),
                  _buildRow('Sugeridos', sugeridos),
                  const SizedBox(height: 30),
                ],
              ),
      ),
    );
  }
}
