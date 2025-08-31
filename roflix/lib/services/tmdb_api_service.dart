import 'package:dio/dio.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/cast.dart';
import '../models/video.dart';

class TMDbApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '8265bd1679663a7ea12ac168da84d2e8';
  
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    queryParameters: {'api_key': _apiKey, 'language': 'es-ES'},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // Obtener películas populares
  static Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/popular', queryParameters: {'page': page});
      final List<dynamic> moviesJson = response.data['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al cargar películas populares: $e');
    }
  }

  // Obtener películas en cartelera
  static Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/now_playing', queryParameters: {'page': page});
      final List<dynamic> moviesJson = response.data['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al cargar películas en cartelera: $e');
    }
  }

  // Obtener películas mejor calificadas
  static Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/top_rated', queryParameters: {'page': page});
      final List<dynamic> moviesJson = response.data['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al cargar películas mejor calificadas: $e');
    }
  }

  // Obtener películas próximas
  static Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/upcoming', queryParameters: {'page': page});
      final List<dynamic> moviesJson = response.data['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al cargar películas próximas: $e');
    }
  }

  // Buscar películas
  static Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get('/search/movie', queryParameters: {
        'query': query,
        'page': page,
      });
      final List<dynamic> moviesJson = response.data['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al buscar películas: $e');
    }
  }

  // Obtener detalles de película con cast y videos
  static Future<MovieDetail> getMovieDetails(int movieId) async {
    try {
      // Obtener detalles básicos
      final detailsResponse = await _dio.get('/movie/$movieId');
      final movieDetail = MovieDetail.fromJson(detailsResponse.data);

      // Obtener cast
      final creditsResponse = await _dio.get('/movie/$movieId/credits');
      final List<dynamic> castJson = creditsResponse.data['cast'];
      final cast = castJson.take(10).map((json) => Cast.fromJson(json)).toList();

      // Obtener videos
      final videosResponse = await _dio.get('/movie/$movieId/videos');
      final List<dynamic> videosJson = videosResponse.data['results'];
      final videos = videosJson.map((json) => Video.fromJson(json)).toList();

      return MovieDetail(
        id: movieDetail.id,
        title: movieDetail.title,
        overview: movieDetail.overview,
        posterPath: movieDetail.posterPath,
        backdropPath: movieDetail.backdropPath,
        voteAverage: movieDetail.voteAverage,
        voteCount: movieDetail.voteCount,
        releaseDate: movieDetail.releaseDate,
        genres: movieDetail.genres,
        runtime: movieDetail.runtime,
        status: movieDetail.status,
        tagline: movieDetail.tagline,
        cast: cast,
        videos: videos,
        adult: movieDetail.adult,
        originalLanguage: movieDetail.originalLanguage,
        originalTitle: movieDetail.originalTitle,
        popularity: movieDetail.popularity,
      );
    } catch (e) {
      throw Exception('Error al cargar detalles de la película: $e');
    }
  }

  // Obtener películas similares
  static Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      final response = await _dio.get('/movie/$movieId/similar', queryParameters: {'page': page});
      final List<dynamic> moviesJson = response.data['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al cargar películas similares: $e');
    }
  }

  // URLs de imágenes
  static String getPosterUrl(String posterPath, {String size = 'w500'}) {
    if (posterPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/$size$posterPath';
  }

  static String getBackdropUrl(String backdropPath, {String size = 'w1280'}) {
    if (backdropPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/$size$backdropPath';
  }

  static String getProfileUrl(String profilePath, {String size = 'w185'}) {
    if (profilePath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/$size$profilePath';
  }
}
