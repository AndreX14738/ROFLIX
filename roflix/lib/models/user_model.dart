class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final List<int> favoriteMovieIds;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.createdAt,
    required this.lastLoginAt,
    required this.favoriteMovieIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      photoURL: json['photoURL'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      lastLoginAt: DateTime.fromMillisecondsSinceEpoch(json['lastLoginAt'] ?? 0),
      favoriteMovieIds: List<int>.from(json['favoriteMovieIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt.millisecondsSinceEpoch,
      'favoriteMovieIds': favoriteMovieIds,
    };
  }

  // Crear copia con modificaciones
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<int>? favoriteMovieIds,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      favoriteMovieIds: favoriteMovieIds ?? this.favoriteMovieIds,
    );
  }

  // Verificar si una película está en favoritos
  bool isFavorite(int movieId) {
    return favoriteMovieIds.contains(movieId);
  }

  // Agregar película a favoritos
  UserModel addFavorite(int movieId) {
    if (!favoriteMovieIds.contains(movieId)) {
      final newFavorites = List<int>.from(favoriteMovieIds);
      newFavorites.add(movieId);
      return copyWith(favoriteMovieIds: newFavorites);
    }
    return this;
  }

  // Remover película de favoritos
  UserModel removeFavorite(int movieId) {
    final newFavorites = List<int>.from(favoriteMovieIds);
    newFavorites.remove(movieId);
    return copyWith(favoriteMovieIds: newFavorites);
  }

  // Nombre a mostrar (displayName o email)
  String get name {
    if (displayName.isNotEmpty) return displayName;
    return email.split('@').first;
  }

  // Iniciales para avatar
  String get initials {
    if (displayName.isNotEmpty) {
      final parts = displayName.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        return displayName.substring(0, 1).toUpperCase();
      }
    }
    return email.substring(0, 1).toUpperCase();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() {
    return 'UserModel{uid: $uid, email: $email, displayName: $displayName}';
  }
}
