class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<int> genreIds;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final bool video;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      video: json['video'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'adult': adult,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'popularity': popularity,
      'video': video,
    };
  }

  // URL completa del póster
  String get fullPosterUrl {
    if (posterPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  // URL completa del backdrop
  String get fullBackdropUrl {
    if (backdropPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w1280$backdropPath';
  }

  // Fecha formateada
  String get formattedReleaseDate {
    if (releaseDate.isEmpty) return 'Sin fecha';
    try {
      final date = DateTime.parse(releaseDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return releaseDate;
    }
  }

  // Año de lanzamiento
  String get releaseYear {
    if (releaseDate.isEmpty) return '';
    try {
      final date = DateTime.parse(releaseDate);
      return date.year.toString();
    } catch (e) {
      return '';
    }
  }

  // Calificación en estrellas (de 0 a 5)
  double get starRating => voteAverage / 2;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, voteAverage: $voteAverage}';
  }
}
