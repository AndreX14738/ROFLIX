import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/movie.dart';

import '../../providers/movie_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/movie_card.dart';

class MovieDetailScreenNew extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreenNew({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreenNew> createState() => _MovieDetailScreenNewState();
}

class _MovieDetailScreenNewState extends State<MovieDetailScreenNew> {
  YoutubePlayerController? _youtubeController;
  bool _showTrailer = false;
  String? get trailerKey {
    // Si el objeto movie es un Movie, intenta obtener el trailer_key del Map original si existe
    try {
      final dynamic movieObj = widget.movie;
      if (movieObj is Movie && movieObj.title.isNotEmpty) {
        // Buscar el trailer_key en la lista demo según el título
        final demo = _demoTrailers[movieObj.title];
        if (demo != null) return demo;
      }
      if (movieObj is Map<String, dynamic> && movieObj.containsKey('trailer_key')) {
        return movieObj['trailer_key'] as String?;
      }
    } catch (_) {}
    return null;
  }

  // Mapeo de títulos demo a trailer_key
  static const Map<String, String> _demoTrailers = {
    'Inception': '8hP9D6kZseM',
    'Interstellar': 'zSWdZVtXT7E',
    'The Dark Knight': 'EXeTwQWrcwY',
    'Avengers: Endgame': 'TcMBFSGVi1c',
    'Spider-Man: No Way Home': 'JfVOs4VSpmA',
    'Joker': 'zAGVQLHvwOY',
    'Black Panther': 'xjDjIWPwcPU',
    'Frozen II': 'Zi4LMpSDccc',
    'Toy Story 4': 'wmiIUN-7qhE',
    'Parasite': '5xH0HfJHsaY',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadMovieDetails(widget.movie.id);
    });
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _initializeTrailer(String videoKey) {
    if (_youtubeController != null) {
      _youtubeController!.dispose();
    }
    
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoKey,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        captionLanguage: 'es',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          final movieDetail = movieProvider.currentMovieDetails;

          return CustomScrollView(
            slivers: [
              // AppBar con imagen de fondo
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  Consumer<FavoritesProvider>(
                    builder: (context, favProvider, child) {
                      final isFavorite = favProvider.isFavorite(widget.movie.id);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? const Color(0xFFE50914) : Colors.white,
                        ),
                        onPressed: () => _toggleFavorite(),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagen de fondo
                      Hero(
                        tag: 'movie-backdrop-${widget.movie.id}',
                        child: CachedNetworkImage(
                          imageUrl: widget.movie.fullBackdropUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[900],
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[900],
                            child: const Icon(Icons.error, color: Colors.white54),
                          ),
                        ),
                      ),
                      
                      // Gradiente
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      
                      // Botón de reproducir tráiler
                      if (movieDetail?.trailer != null)
                        Center(
                          child: GestureDetector(
                            onTap: () => _toggleTrailer(movieDetail!.trailer!.key),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _showTrailer ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Contenido principal
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Botones de acción
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Función de reproducción simulada'),
                                  backgroundColor: Color(0xFFE50914),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Reproducir'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE50914),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final key = trailerKey ?? movieDetail?.trailer?.key;
                              if (key != null) {
                                final url = 'https://www.youtube.com/watch?v=$key';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No se pudo abrir YouTube'),
                                      backgroundColor: Color(0xFFE50914),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.ondemand_video),
                            label: const Text('Ver trailer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Título y información básica
                      Text(
                        widget.movie.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            widget.movie.releaseYear,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          if (movieDetail != null && movieDetail.runtime > 0) ...[
                            const SizedBox(width: 16),
                            Text(
                              movieDetail.formattedRuntime,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ],
                      ),
                      
                      if (movieDetail != null && movieDetail.genres.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: movieDetail.genres.map((genre) {
                            return Chip(
                              label: Text(
                                genre.name,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: const Color(0xFF333333),
                              side: BorderSide.none,
                            );
                          }).toList(),
                        ),
                      ],
                      
                      const SizedBox(height: 20),
                      
                      // Reproductor de tráiler
                      if (_showTrailer && _youtubeController != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: YoutubePlayer(
                            controller: _youtubeController!,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: const Color(0xFFE50914),
                          ),
                        ),
                      
                      // Sinopsis
                      Text(
                        'Sinopsis',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.movie.overview.isNotEmpty 
                            ? widget.movie.overview 
                            : 'No hay sinopsis disponible.',
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      
                      // Reparto
                      if (movieDetail != null && movieDetail.cast.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Reparto Principal',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: movieDetail.cast.length,
                            itemBuilder: (context, index) {
                              final actor = movieDetail.cast[index];
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: actor.profilePath.isNotEmpty
                                          ? CachedNetworkImageProvider(actor.fullProfileUrl)
                                          : null,
                                      backgroundColor: Colors.grey[700],
                                      child: actor.profilePath.isEmpty
                                          ? const Icon(Icons.person, color: Colors.white54)
                                          : null,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      actor.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      actor.character,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      
                      // Películas similares
                      if (movieProvider.similarMovies.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Películas Similares',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: movieProvider.similarMovies.length,
                            itemBuilder: (context, index) {
                              final movie = movieProvider.similarMovies[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: MovieCard(
                                  movie: movie,
                                  onTap: () => _navigateToMovieDetail(movie),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggleTrailer(String videoKey) {
    setState(() {
      if (_showTrailer) {
        _showTrailer = false;
        _youtubeController?.dispose();
        _youtubeController = null;
      } else {
        _initializeTrailer(videoKey);
        _showTrailer = true;
      }
    });
  }

  void _toggleFavorite() async {
  // Obtener el email del usuario logueado (demo)
  String userEmail = 'admin@roflix.com';
    final favProvider = Provider.of<FavoritesProvider>(context, listen: false);
    final isFav = favProvider.isFavorite(widget.movie.id);
    if (isFav) {
      await favProvider.removeFromFavorites(userEmail, widget.movie.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Película removida de favoritos'),
          backgroundColor: Color(0xFFE50914),
        ),
      );
    } else {
      await favProvider.addToFavorites(userEmail, widget.movie);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Película agregada a favoritos'),
          backgroundColor: Color(0xFFE50914),
        ),
      );
    }
  }

  void _navigateToMovieDetail(Movie movie) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreenNew(movie: movie),
      ),
    );
  }
}
