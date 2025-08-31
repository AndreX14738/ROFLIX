class Cast {
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String profilePath;
  final int castId;
  final String character;
  final String creditId;
  final int order;

  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      adult: json['adult'] ?? false,
      gender: json['gender'] ?? 0,
      id: json['id'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      profilePath: json['profile_path'] ?? '',
      castId: json['cast_id'] ?? 0,
      character: json['character'] ?? '',
      creditId: json['credit_id'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  // URL completa del perfil
  String get fullProfileUrl {
    if (profilePath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w185$profilePath';
  }

  // Género como string
  String get genderString {
    switch (gender) {
      case 1:
        return 'Femenino';
      case 2:
        return 'Masculino';
      default:
        return 'No especificado';
    }
  }
}

class Crew {
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String profilePath;
  final String creditId;
  final String department;
  final String job;

  Crew({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.creditId,
    required this.department,
    required this.job,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      adult: json['adult'] ?? false,
      gender: json['gender'] ?? 0,
      id: json['id'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      profilePath: json['profile_path'] ?? '',
      creditId: json['credit_id'] ?? '',
      department: json['department'] ?? '',
      job: json['job'] ?? '',
    );
  }

  // URL completa del perfil
  String get fullProfileUrl {
    if (profilePath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w185$profilePath';
  }
}

class Credits {
  final int id;
  final List<Cast> cast;
  final List<Crew> crew;

  Credits({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory Credits.fromJson(Map<String, dynamic> json) {
    return Credits(
      id: json['id'] ?? 0,
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) => Cast.fromJson(e))
              .toList() ??
          [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) => Crew.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Obtener director principal
  String get director {
    final directors = crew.where((c) => c.job == 'Director').toList();
    if (directors.isNotEmpty) {
      return directors.first.name;
    }
    return 'Desconocido';
  }

  // Obtener principales actores (primeros 5)
  List<Cast> get mainCast {
    return cast.take(5).toList();
  }
}
