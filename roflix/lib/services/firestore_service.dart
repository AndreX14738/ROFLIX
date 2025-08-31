// Demo FirestoreService - Sin Firebase para funcionamiento demo

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  // Listas demo en memoria
  final List<Map<String, dynamic>> _favoriteMovies = [];
  final List<Map<String, dynamic>> _watchlist = [];
  final List<String> _favoriteMovieIds = [];
  final Map<String, dynamic> _userPreferences = {};

  // Obtener películas favoritas del usuario
  Future<List<Map<String, dynamic>>> getUserFavoriteMovies(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_favoriteMovies);
  }

  // Obtener IDs de películas favoritas
  Future<List<String>> getUserFavoriteMovieIds(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_favoriteMovieIds);
  }

  // Verificar si una película es favorita
  Future<bool> isMovieFavorite(String userId, int movieId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _favoriteMovieIds.contains(movieId.toString());
  }

  // Agregar película a favoritos
  Future<void> addMovieToFavorites(String userId, Map<String, dynamic> movie) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Verificar si ya está en favoritos
      if (!_favoriteMovieIds.contains(movie['id'].toString())) {
        _favoriteMovies.add(movie);
        _favoriteMovieIds.add(movie['id'].toString());
        // Película agregada a favoritos (modo demo)
      }
    } catch (e) {
      throw Exception('Error al agregar a favoritos: ${e.toString()}');
    }
  }

  // Remover película de favoritos
  Future<void> removeMovieFromFavorites(String userId, int movieId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _favoriteMovieIds.remove(movieId.toString());
      _favoriteMovies.removeWhere((movie) => movie['id'] == movieId);
      // Película removida de favoritos (modo demo)
    } catch (e) {
      throw Exception('Error al remover de favoritos: ${e.toString()}');
    }
  }

  // Obtener lista de reproducción del usuario
  Future<List<Map<String, dynamic>>> getUserWatchlist(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_watchlist);
  }

  // Agregar película a lista de reproducción
  Future<void> addMovieToWatchlist(String userId, Map<String, dynamic> movie) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Verificar si ya está en la lista
      if (!_watchlist.any((m) => m['id'] == movie['id'])) {
        _watchlist.add(movie);
        // Película agregada a lista de reproducción (modo demo)
      }
    } catch (e) {
      throw Exception('Error al agregar a lista: ${e.toString()}');
    }
  }

  // Remover película de lista de reproducción
  Future<void> removeMovieFromWatchlist(String userId, int movieId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _watchlist.removeWhere((movie) => movie['id'] == movieId);
      // Película removida de lista de reproducción (modo demo)
    } catch (e) {
      throw Exception('Error al remover de lista: ${e.toString()}');
    }
  }

  // Crear documento de usuario
  Future<void> createUserDocument(String userId, Map<String, dynamic> userData) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      _userPreferences[userId] = {
        ...userData,
        'createdAt': DateTime.now().toIso8601String(),
        'lastLogin': DateTime.now().toIso8601String(),
      };
      
      // Documento de usuario creado (modo demo)
    } catch (e) {
      throw Exception('Error al crear documento: ${e.toString()}');
    }
  }

  // Actualizar documento de usuario
  Future<void> updateUserDocument(String userId, Map<String, dynamic> updates) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (_userPreferences.containsKey(userId)) {
        _userPreferences[userId] = {
          ..._userPreferences[userId],
          ...updates,
          'updatedAt': DateTime.now().toIso8601String(),
        };
      } else {
        _userPreferences[userId] = {
          ...updates,
          'createdAt': DateTime.now().toIso8601String(),
        };
      }
      
      // Documento de usuario actualizado (modo demo)
    } catch (e) {
      throw Exception('Error al actualizar documento: ${e.toString()}');
    }
  }

  // Obtener datos del usuario
  Future<Map<String, dynamic>?> getUserDocument(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _userPreferences[userId];
    } catch (e) {
      throw Exception('Error al obtener documento: ${e.toString()}');
    }
  }

  // Actualizar última vez que se conectó
  Future<void> updateUserLastLogin(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      if (_userPreferences.containsKey(userId)) {
        _userPreferences[userId]['lastLogin'] = DateTime.now().toIso8601String();
      }
    } catch (e) {
      // Error al actualizar último login (modo demo)
    }
  }

  // Obtener preferencias del usuario
  Future<Map<String, dynamic>> getUserPreferences(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _userPreferences[userId] ?? {
      'favoriteGenres': <String>[],
      'preferredLanguage': 'es',
      'adultContent': false,
      'notifications': {
        'newReleases': true,
        'recommendations': true,
        'updates': false,
      },
    };
  }

  // Actualizar preferencias del usuario
  Future<void> updateUserPreferences(String userId, Map<String, dynamic> preferences) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (_userPreferences.containsKey(userId)) {
        _userPreferences[userId]['preferences'] = preferences;
      } else {
        _userPreferences[userId] = {'preferences': preferences};
      }
      
      // Preferencias actualizadas (modo demo)
    } catch (e) {
      throw Exception('Error al actualizar preferencias: ${e.toString()}');
    }
  }

  // Limpiar datos (útil para cerrar sesión)
  void clearUserData() {
    _favoriteMovies.clear();
    _watchlist.clear();
    _favoriteMovieIds.clear();
    _userPreferences.clear();
  }

  // Obtener estadísticas del usuario
  Future<Map<String, int>> getUserStats(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return {
      'favoriteMovies': _favoriteMovies.length,
      'watchlistMovies': _watchlist.length,
      'totalInteractions': _favoriteMovies.length + _watchlist.length,
    };
  }
}
