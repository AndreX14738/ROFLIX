
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/cast.dart';
import '../models/video.dart';

class TMDBService {
  static const String _apiKey = 'TU_API_KEY_AQUI';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json;charset=utf-8',
  };
  

  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p';

  // Obtener películas populares
  static Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
  final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&page=$page&language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> moviesJson = data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas populares');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener películas en cartelera
  static Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
  final url = Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey&page=$page&language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> moviesJson = data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas en cartelera');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener películas mejor calificadas
  static Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
  final url = Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&page=$page&language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> moviesJson = data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas mejor calificadas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener películas próximas
  static Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
  final url = Uri.parse('$_baseUrl/movie/upcoming?api_key=$_apiKey&page=$page&language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> moviesJson = data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas próximas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Buscar películas
  static Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse('$_baseUrl/search/movie?query=$encodedQuery&page=$page&language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> moviesJson = data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al buscar películas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Buscar películas y devolver mapas simples (para autocompletado y búsqueda rápida)
  static Future<List<Map<String, dynamic>>> searchMoviesAsMap(String query, {int page = 1}) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse('$_baseUrl/search/movie?query=$encodedQuery&page=$page&language=es-ES');
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> moviesJson = data['results'];
        return moviesJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al buscar películas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener detalles de película
  static Future<MovieDetail> getMovieDetails(int movieId) async {
    try {
      final url = Uri.parse('$_baseUrl/movie/$movieId?language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
  return MovieDetail.fromJson(data);
      } else {
        throw Exception('Error al cargar detalles de la película');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener créditos de película (reparto y equipo)
  static Future<Credits> getMovieCredits(int movieId) async {
    try {
      final url = Uri.parse('$_baseUrl/movie/$movieId/credits?language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Credits.fromJson(data);
      } else {
        throw Exception('Error al cargar créditos de la película');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener videos de película (tráilers)
  static Future<Videos> getMovieVideos(int movieId) async {
    try {
      final url = Uri.parse('$_baseUrl/movie/$movieId/videos?language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Videos.fromJson(data);
      } else {
        throw Exception('Error al cargar videos de la película');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener películas similares
  static Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      final url = Uri.parse('$_baseUrl/movie/$movieId/similar?page=$page&language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> moviesJson = data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas similares');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener recomendaciones de películas
  static Future<List<Movie>> getMovieRecommendations(int movieId, {int page = 1}) async {
    try {
      final url = Uri.parse('$_baseUrl/movie/$movieId/recommendations?page=$page&language=es-ES');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> moviesJson = data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar recomendaciones');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // URLs de imágenes
  static String getPosterUrl(String posterPath, {String size = 'w500'}) {
    if (posterPath.isEmpty) return '';
    return '$_imageBaseUrl/$size$posterPath';
  }

  static String getBackdropUrl(String backdropPath, {String size = 'w1280'}) {
    if (backdropPath.isEmpty) return '';
    return '$_imageBaseUrl/$size$backdropPath';
  }

  static String getProfileUrl(String profilePath, {String size = 'w185'}) {
    if (profilePath.isEmpty) return '';
    return '$_imageBaseUrl/$size$profilePath';
  }
}
