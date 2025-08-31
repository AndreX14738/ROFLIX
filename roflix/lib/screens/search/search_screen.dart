import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/movie_provider.dart';
import '../../widgets/movie_card.dart';
import '../movie_detail/movie_detail_screen.dart';

class SearchScreenNew extends StatefulWidget {
  const SearchScreenNew({super.key});

  @override
  State<SearchScreenNew> createState() => _SearchScreenNewState();
}

class _SearchScreenNewState extends State<SearchScreenNew> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final movieProvider = context.read<MovieProvider>();
      if (movieProvider.canLoadMoreSearch && _currentQuery.isNotEmpty) {
        movieProvider.searchMovies(_currentQuery);
      }
    }
  }

  void _onSearchChanged(String query) {
    if (query.trim() != _currentQuery) {
      _currentQuery = query.trim();
      if (_currentQuery.isNotEmpty) {
        context.read<MovieProvider>().searchMovies(_currentQuery, refresh: true);
      } else {
        context.read<MovieProvider>().clearSearchResults();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF232323),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Buscar películas...',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.search, color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white54),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (_currentQuery.isEmpty) {
            return _buildEmptyState();
          }

          if (movieProvider.searchResults.isEmpty && movieProvider.isLoadingSearch) {
            return _buildLoadingState();
          }

          if (movieProvider.searchResults.isEmpty && !movieProvider.isLoadingSearch) {
            return _buildNoResultsState();
          }

          return _buildSearchResults(movieProvider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 80,
            color: Colors.white24,
          ),
          SizedBox(height: 16),
          Text(
            'Busca tu película favorita',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Escribe el nombre de una película para comenzar',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
            'Buscando películas...',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.movie_filter_outlined,
            size: 80,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron resultados',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(MovieProvider movieProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Resultados para "$_currentQuery"',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.67,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: movieProvider.searchResults.length + 
                       (movieProvider.isLoadingSearch ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= movieProvider.searchResults.length) {
                return _buildLoadingCard();
              }

              final movie = movieProvider.searchResults[index];
              return MovieCard(
                movie: movie,
                onTap: () => _navigateToMovieDetail(movie),
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE50914),
          strokeWidth: 2,
        ),
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
