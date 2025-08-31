
// Servicio de favoritos demo sin Firebase
class FavoritesService {
	static final List<Map<String, dynamic>> _favorites = [];

	static Future<void> addFavorite(Map<String, dynamic> movie) async {
		// Evitar duplicados
		if (!_favorites.any((m) => m['id'] == movie['id'])) {
			_favorites.add(movie);
		}
	}

	static List<Map<String, dynamic>> getFavorites() {
		return List.unmodifiable(_favorites);
	}

	static Future<void> removeFavorite(int id) async {
		_favorites.removeWhere((m) => m['id'] == id);
	}
}
