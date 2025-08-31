class Video {
  final String iso6391;
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;

  Video({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      iso6391: json['iso_639_1'] ?? '',
      iso31661: json['iso_3166_1'] ?? '',
      name: json['name'] ?? '',
      key: json['key'] ?? '',
      site: json['site'] ?? '',
      size: json['size'] ?? 0,
      type: json['type'] ?? '',
      official: json['official'] ?? false,
      publishedAt: json['published_at'] ?? '',
      id: json['id'] ?? '',
    );
  }

  // URL de YouTube
  String get youtubeUrl {
    if (site == 'YouTube' && key.isNotEmpty) {
      return 'https://www.youtube.com/watch?v=$key';
    }
    return '';
  }

  // URL de thumbnail de YouTube
  String get youtubeThumbnailUrl {
    if (site == 'YouTube' && key.isNotEmpty) {
      return 'https://img.youtube.com/vi/$key/mqdefault.jpg';
    }
    return '';
  }

  // Es un tráiler oficial
  bool get isTrailer {
    return type.toLowerCase() == 'trailer';
  }

  // Es un teaser
  bool get isTeaser {
    return type.toLowerCase() == 'teaser';
  }

  // Es de YouTube
  bool get isYouTube {
    return site.toLowerCase() == 'youtube';
  }
}

class Videos {
  final int id;
  final List<Video> results;

  Videos({
    required this.id,
    required this.results,
  });

  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
      id: json['id'] ?? 0,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Video.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Obtener tráiler principal (oficial si existe)
  Video? get mainTrailer {
    // Buscar tráiler oficial primero
    final officialTrailers = results
        .where((v) => v.isTrailer && v.official && v.isYouTube)
        .toList();
    
    if (officialTrailers.isNotEmpty) {
      return officialTrailers.first;
    }

    // Si no hay oficial, buscar cualquier tráiler
    final trailers = results
        .where((v) => v.isTrailer && v.isYouTube)
        .toList();
    
    if (trailers.isNotEmpty) {
      return trailers.first;
    }

    // Si no hay tráiler, buscar teaser
    final teasers = results
        .where((v) => v.isTeaser && v.isYouTube)
        .toList();
    
    if (teasers.isNotEmpty) {
      return teasers.first;
    }

    return null;
  }

  // Obtener todos los tráilers de YouTube
  List<Video> get youtubeTrailers {
    return results
        .where((v) => (v.isTrailer || v.isTeaser) && v.isYouTube)
        .toList();
  }
}
