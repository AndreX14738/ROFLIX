import 'cast.dart';
import 'video.dart';

class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<Genre> genres;
  final int runtime;
  final String status;
  final String tagline;
  final List<Cast> cast;
  final List<Video> videos;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genres,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.cast,
    required this.videos,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genres: (json['genres'] as List<dynamic>?)
          ?.map((g) => Genre.fromJson(g))
          .toList() ?? [],
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      cast: [], // Will be populated separately
      videos: [], // Will be populated separately
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
    );
  }

  String get fullPosterUrl {
    if (posterPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropUrl {
    if (backdropPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w1280$backdropPath';
  }

  String get formattedRuntime {
    if (runtime <= 0) return '';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get releaseYear {
    if (releaseDate.isEmpty) return '';
    try {
      final date = DateTime.parse(releaseDate);
      return date.year.toString();
    } catch (e) {
      return '';
    }
  }

  double get starRating => voteAverage / 2;

  String get genresString => genres.map((g) => g.name).join(', ');

  Video? get trailer {
    return videos
        .where((v) => v.type == 'Trailer' && v.site == 'YouTube')
        .isNotEmpty
        ? videos.firstWhere((v) => v.type == 'Trailer' && v.site == 'YouTube')
        : null;
  }
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

