import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/tmdb_api_service.dart';

class MovieProvider extends ChangeNotifier {
  // Listas de películas
  List<Movie> _popularMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _searchResults = [];

  // Estados de carga
  bool _isLoadingPopular = false;
  bool _isLoadingNowPlaying = false;
  bool _isLoadingTopRated = false;
  bool _isLoadingUpcoming = false;
  bool _isLoadingSearch = false;
  bool _isLoadingDetails = false;

  // Paginación
  int _popularPage = 1;
  int _nowPlayingPage = 1;
  int _topRatedPage = 1;
  int _upcomingPage = 1;
  int _searchPage = 1;

  // Búsqueda
  String _currentSearchQuery = '';

  // Detalles de película actual
  MovieDetail? _currentMovieDetails;
  List<Movie> _similarMovies = [];

  // Error messages
  String? _errorMessage;

  // Getters
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get searchResults => _searchResults;

  bool get isLoadingPopular => _isLoadingPopular;
  bool get isLoadingNowPlaying => _isLoadingNowPlaying;
  bool get isLoadingTopRated => _isLoadingTopRated;
  bool get isLoadingUpcoming => _isLoadingUpcoming;
  bool get isLoadingSearch => _isLoadingSearch;
  bool get isLoadingDetails => _isLoadingDetails;

  String get currentSearchQuery => _currentSearchQuery;
  String? get errorMessage => _errorMessage;

  MovieDetail? get currentMovieDetails => _currentMovieDetails;
  List<Movie> get similarMovies => _similarMovies;

  // Cargar películas populares
  Future<void> loadPopularMovies({bool refresh = false}) async {
    if (refresh) {
      _popularPage = 1;
      _popularMovies.clear();
    }

    _isLoadingPopular = true;
    _clearError();
    notifyListeners();

    try {
      final movies = await TMDbApiService.getPopularMovies(page: _popularPage);
      if (refresh) {
        _popularMovies = movies;
      } else {
        _popularMovies.addAll(movies);
      }
      _popularPage++;
    } catch (e) {
      _setError('Error al cargar películas populares: $e');
    }

    _isLoadingPopular = false;
    notifyListeners();
  }

  // Cargar películas en cartelera
  Future<void> loadNowPlayingMovies({bool refresh = false}) async {
    if (refresh) {
      _nowPlayingPage = 1;
      _nowPlayingMovies.clear();
    }

    _isLoadingNowPlaying = true;
    _clearError();
    notifyListeners();

    try {
      final movies = await TMDbApiService.getNowPlayingMovies(page: _nowPlayingPage);
      if (refresh) {
        _nowPlayingMovies = movies;
      } else {
        _nowPlayingMovies.addAll(movies);
      }
      _nowPlayingPage++;
    } catch (e) {
      _setError('Error al cargar películas en cartelera: $e');
    }

    _isLoadingNowPlaying = false;
    notifyListeners();
  }

  // Cargar películas mejor calificadas
  Future<void> loadTopRatedMovies({bool refresh = false}) async {
    if (refresh) {
      _topRatedPage = 1;
      _topRatedMovies.clear();
    }

    _isLoadingTopRated = true;
    _clearError();
    notifyListeners();

    try {
      final movies = await TMDbApiService.getTopRatedMovies(page: _topRatedPage);
      if (refresh) {
        _topRatedMovies = movies;
      } else {
        _topRatedMovies.addAll(movies);
      }
      _topRatedPage++;
    } catch (e) {
      _setError('Error al cargar películas mejor calificadas: $e');
    }

    _isLoadingTopRated = false;
    notifyListeners();
  }

  // Cargar películas próximas
  Future<void> loadUpcomingMovies({bool refresh = false}) async {
    if (refresh) {
      _upcomingPage = 1;
      _upcomingMovies.clear();
    }

    _isLoadingUpcoming = true;
    _clearError();
    notifyListeners();

    try {
      final movies = await TMDbApiService.getUpcomingMovies(page: _upcomingPage);
      if (refresh) {
        _upcomingMovies = movies;
      } else {
        _upcomingMovies.addAll(movies);
      }
      _upcomingPage++;
    } catch (e) {
      _setError('Error al cargar películas próximas: $e');
    }

    _isLoadingUpcoming = false;
    notifyListeners();
  }

  // Buscar películas
  Future<void> searchMovies(String query, {bool refresh = false}) async {
    if (query.isEmpty) {
      _searchResults.clear();
      _currentSearchQuery = '';
      notifyListeners();
      return;
    }

    if (refresh || query != _currentSearchQuery) {
      _searchPage = 1;
      _searchResults.clear();
      _currentSearchQuery = query;
    }

    _isLoadingSearch = true;
    _clearError();
    notifyListeners();

    try {
      final movies = await TMDbApiService.searchMovies(query, page: _searchPage);
      if (refresh || query != _currentSearchQuery) {
        _searchResults = movies;
      } else {
        _searchResults.addAll(movies);
      }
      _searchPage++;
    } catch (e) {
      _setError('Error al buscar películas: $e');
    }

    _isLoadingSearch = false;
    notifyListeners();
  }

  // Cargar detalles de película
  Future<void> loadMovieDetails(int movieId) async {
    _isLoadingDetails = true;
    _clearError();
    notifyListeners();

    try {
      // Cargar detalles y películas similares
      final results = await Future.wait([
        TMDbApiService.getMovieDetails(movieId),
        TMDbApiService.getSimilarMovies(movieId),
      ]);

      _currentMovieDetails = results[0] as MovieDetail;
      _similarMovies = results[1] as List<Movie>;
    } catch (e) {
      _setError('Error al cargar detalles de la película: $e');
    }

    _isLoadingDetails = false;
    notifyListeners();
  }

  // Limpiar detalles de película
  void clearMovieDetails() {
    _currentMovieDetails = null;
    _similarMovies.clear();
    notifyListeners();
  }

  // Cargar todas las categorías iniciales
  Future<void> loadInitialMovies() async {
    await Future.wait([
      loadPopularMovies(refresh: true),
      loadNowPlayingMovies(refresh: true),
      loadTopRatedMovies(refresh: true),
    ]);
  }

  // Refresh general
  Future<void> refreshAll() async {
    await Future.wait([
      loadPopularMovies(refresh: true),
      loadNowPlayingMovies(refresh: true),
      loadTopRatedMovies(refresh: true),
      loadUpcomingMovies(refresh: true),
    ]);
  }

  // Limpiar resultados de búsqueda
  void clearSearchResults() {
    _searchResults.clear();
    _currentSearchQuery = '';
    _searchPage = 1;
    notifyListeners();
  }

  // Obtener película por ID de alguna lista cargada
  Movie? getMovieById(int movieId) {
    for (final movie in [..._popularMovies, ..._nowPlayingMovies, 
                         ..._topRatedMovies, ..._upcomingMovies, 
                         ..._searchResults, ..._similarMovies]) {
      if (movie.id == movieId) {
        return movie;
      }
    }
    return null;
  }

  // Métodos privados para manejo de estado
  void _setError(String error) {
    _errorMessage = error;
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Limpiar error manualmente
  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Verificar si hay más páginas para cargar
  bool get canLoadMorePopular => !_isLoadingPopular;
  bool get canLoadMoreNowPlaying => !_isLoadingNowPlaying;
  bool get canLoadMoreTopRated => !_isLoadingTopRated;
  bool get canLoadMoreUpcoming => !_isLoadingUpcoming;
  bool get canLoadMoreSearch => !_isLoadingSearch && _currentSearchQuery.isNotEmpty;
}
