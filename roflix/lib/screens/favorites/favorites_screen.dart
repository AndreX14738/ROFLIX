import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/movie_card.dart';
import '../movie_detail/movie_detail_screen.dart';

class FavoritesScreenNew extends StatefulWidget {
  const FavoritesScreenNew({super.key});

  @override
  State<FavoritesScreenNew> createState() => _FavoritesScreenNewState();
}

class _FavoritesScreenNewState extends State<FavoritesScreenNew> {
  @override
  void initState() {
    super.initState();
    // Cargar favoritos del usuario demo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavoriteMovies('demo_user');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Mis Favoritos',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favProvider, child) {
              if (favProvider.favoriteMovies.isNotEmpty) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'clear_all') {
                      _showClearAllDialog();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Icon(Icons.clear_all, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Limpiar todos'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favProvider, child) {
          if (favProvider.isLoading) {
            return _buildLoadingState();
          }

          if (favProvider.favoriteMovies.isEmpty) {
            return _buildEmptyState();
          }

          return _buildFavoritesList(favProvider);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFFE50914),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando favoritos...',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_outline_rounded,
            size: 80,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes favoritos aún',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explora películas y agrega tus favoritas',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Cambiar a la pestaña de inicio
              DefaultTabController.of(context).animateTo(0);
            },
            icon: const Icon(Icons.explore),
            label: const Text('Explorar Películas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50914),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(FavoritesProvider favProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Estadísticas
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total',
                favProvider.favoriteCount.toString(),
                Icons.movie_rounded,
              ),
              _buildStatItem(
                'Promedio',
                favProvider.favoriteStats['averageRating'].toStringAsFixed(1),
                Icons.star_rounded,
              ),
              _buildStatItem(
                'Este Año',
                _getMoviesThisYear(favProvider).toString(),
                Icons.calendar_today_rounded,
              ),
            ],
          ),
        ),

        // Lista de favoritos
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.67,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: favProvider.favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favProvider.favoriteMovies[index];
              return Stack(
                children: [
                  MovieCard(
                    movie: movie,
                    onTap: () => _navigateToMovieDetail(movie),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  
                  // Botón de remover de favoritos
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _removeFromFavorites(movie.id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFE50914),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFE50914), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  int _getMoviesThisYear(FavoritesProvider favProvider) {
    final currentYear = DateTime.now().year;
    return favProvider.favoriteMovies
        .where((movie) => movie.releaseYear == currentYear.toString())
        .length;
  }

  void _removeFromFavorites(int movieId) {
    context.read<FavoritesProvider>().removeFromFavorites('demo_user', movieId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Película removida de favoritos'),
        backgroundColor: Color(0xFFE50914),
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Limpiar Favoritos',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que quieres remover todas las películas de tus favoritos?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FavoritesProvider>().clearAllFavorites('demo_user');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos los favoritos han sido removidos'),
                  backgroundColor: Color(0xFFE50914),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50914),
            ),
            child: const Text('Limpiar Todo'),
          ),
        ],
      ),
    );
  }

  void _navigateToMovieDetail(movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreenNew(movie: movie),
      ),
    );
  }
}
