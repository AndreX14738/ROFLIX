import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _userEmail;
  String? _userId;
  String? _userName;
  String? _errorMessage;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get userName => _userName ?? 'Usuario Demo';
  String? get errorMessage => _errorMessage;

  // Constructor
  AuthProvider() {
    _checkAuthStatus();
  }

  // Verificar estado de autenticación (simulado)
  void _checkAuthStatus() {
    // Para demo, simular que el usuario ya está autenticado
    _isAuthenticated = true;
    _userEmail = 'demo@roflix.com';
    _userId = 'demo_user_123';
    _userName = 'Usuario Demo';
    notifyListeners();
  }

  // Login simulado
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Simulación de login exitoso
      _isAuthenticated = true;
      _userEmail = email;
      _userId = 'user_${email.hashCode}';
      _userName = email.split('@')[0];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Registro simulado
  Future<bool> createUserWithEmailAndPassword(String email, String password, String displayName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Simulación de registro exitoso
      _isAuthenticated = true;
      _userEmail = email;
      _userId = 'user_${email.hashCode}';
      _userName = displayName;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al registrar usuario';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login con Google simulado
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      _isAuthenticated = true;
      _userEmail = 'google.user@gmail.com';
      _userId = 'google_user_456';
      _userName = 'Usuario Google';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión con Google';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _isAuthenticated = false;
    _userEmail = null;
    _userId = null;
    _userName = null;
    _isLoading = false;
    notifyListeners();
  }

  // Resetear contraseña (simulado)
  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
    return true; // Simulación de éxito
  }

  // Actualizar datos del usuario (simulado)
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (userData['displayName'] != null) {
      _userName = userData['displayName'];
    }
    if (userData['email'] != null) {
      _userEmail = userData['email'];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Recargar datos del usuario (simulado)
  Future<void> reloadUserData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _isLoading = false;
    notifyListeners();
  }

  // Limpiar error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Verificar si el usuario tiene email verificado (simulado)
  bool get isEmailVerified => true;

  // Obtener foto de perfil del usuario (simulado)
  String get userPhotoUrl => '';

  // Obtener iniciales del usuario
  String get userInitials {
    if (_userName != null && _userName!.isNotEmpty) {
      return _userName!.substring(0, 1).toUpperCase();
    }
    if (_userEmail != null && _userEmail!.isNotEmpty) {
      return _userEmail!.substring(0, 1).toUpperCase();
    }
    return 'U';
  }
}
