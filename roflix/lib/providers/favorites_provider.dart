import 'package:flutter/material.dart';
import '../models/movie.dart';


class FavoritesProvider extends ChangeNotifier {
  List<Movie> _favoriteMovies = [];
  List<int> _favoriteMovieIds = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Movie> get favoriteMovies => _favoriteMovies;
  List<int> get favoriteMovieIds => _favoriteMovieIds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get favoriteCount => _favoriteMovies.length;

  // Verificar si una película está en favoritos
  bool isFavorite(int movieId) {
    return _favoriteMovieIds.contains(movieId);
  }

  // Cargar películas favoritas del usuario
  Future<void> loadFavoriteMovies(String uid) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

      try {
        // Demo: favoritos locales, sin Firebase
        _favoriteMovieIds = [];
        _favoriteMovies = [];
      } catch (e) {
        _setError('Error al cargar películas favoritas: $e');
      }

    _isLoading = false;
    notifyListeners();
  }

  // Agregar película a favoritos
  Future<bool> addToFavorites(String uid, Movie movie) async {
    _clearError();

      try {
        // Demo: agregar a favoritos localmente
        if (!_favoriteMovieIds.contains(movie.id)) {
          _favoriteMovieIds.add(movie.id);
          _favoriteMovies.insert(0, movie);
        }
        notifyListeners();
        return true;
      } catch (e) {
        _setError('Error al agregar a favoritos: $e');
        return false;
      }
  }

  // Remover película de favoritos
  Future<bool> removeFromFavorites(String uid, int movieId) async {
    _clearError();

      try {
        // Demo: remover de favoritos localmente
        _favoriteMovieIds.remove(movieId);
        _favoriteMovies.removeWhere((movie) => movie.id == movieId);
        notifyListeners();
        return true;
      } catch (e) {
        _setError('Error al remover de favoritos: $e');
        return false;
      }
  }

  // Toggle favorito (agregar o remover)
  Future<bool> toggleFavorite(String uid, Movie movie) async {
    if (isFavorite(movie.id)) {
      return await removeFromFavorites(uid, movie.id);
    } else {
      return await addToFavorites(uid, movie);
    }
  }

  // Limpiar todos los favoritos
  Future<bool> clearAllFavorites(String uid) async {
    _clearError();

      try {
        // Demo: limpiar favoritos localmente
        _favoriteMovies.clear();
        _favoriteMovieIds.clear();
        notifyListeners();
        return true;
      } catch (e) {
        _setError('Error al limpiar favoritos: $e');
        return false;
      }
  }

  // Refrescar favoritos
  Future<void> refreshFavorites(String uid) async {
    await loadFavoriteMovies(uid);
  }

  // Configurar listener en tiempo real para favoritos (simulado para demo)
  void listenToFavorites(String uid) {
    // En la versión demo, no hay streams en tiempo real
    // Se podría implementar con un Timer periódico si se necesita
    
    // Cargar favoritos inicialmente
    loadFavoriteMovies(uid);
  }

  // Obtener película favorita por ID
  Movie? getFavoriteMovieById(int movieId) {
    try {
      return _favoriteMovies.firstWhere((movie) => movie.id == movieId);
    } catch (e) {
      return null;
    }
  }

  // Filtrar favoritos por género
  List<Movie> getFavoritesByGenre(List<int> genreIds) {
    return _favoriteMovies.where((movie) {
      return movie.genreIds.any((id) => genreIds.contains(id));
    }).toList();
  }

  // Buscar en favoritos
  List<Movie> searchInFavorites(String query) {
    if (query.isEmpty) return _favoriteMovies;
    
    final lowercaseQuery = query.toLowerCase();
    return _favoriteMovies.where((movie) {
      return movie.title.toLowerCase().contains(lowercaseQuery) ||
             movie.overview.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Obtener favoritos ordenados por fecha de agregado (más recientes primero)
  List<Movie> get recentFavorites => List.from(_favoriteMovies);

  // Obtener favoritos ordenados por calificación
  List<Movie> get topRatedFavorites {
    final sortedList = List<Movie>.from(_favoriteMovies);
    sortedList.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return sortedList;
  }

  // Obtener estadísticas de favoritos
  Map<String, dynamic> get favoriteStats {
    if (_favoriteMovies.isEmpty) {
      return {
        'total': 0,
        'averageRating': 0.0,
        'topGenres': <String>[],
      };
    }

    // Calcular calificación promedio
    final totalRating = _favoriteMovies.fold<double>(
      0.0, 
      (sum, movie) => sum + movie.voteAverage,
    );
    final averageRating = totalRating / _favoriteMovies.length;

    // Contar géneros (esto requeriría un mapeo de IDs a nombres)
    final genreCounts = <int, int>{};
    for (final movie in _favoriteMovies) {
      for (final genreId in movie.genreIds) {
        genreCounts[genreId] = (genreCounts[genreId] ?? 0) + 1;
      }
    }

    // Obtener top 3 géneros más comunes
    final sortedGenres = genreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return {
      'total': _favoriteMovies.length,
      'averageRating': averageRating,
      'topGenreIds': sortedGenres.take(3).map((e) => e.key).toList(),
    };
  }

  // Métodos privados para manejo de estado
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Limpiar error manualmente
  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Limpiar datos al cerrar sesión
  void clearData() {
    _favoriteMovies.clear();
    _favoriteMovieIds.clear();
    _clearError();
    notifyListeners();
  }
}
