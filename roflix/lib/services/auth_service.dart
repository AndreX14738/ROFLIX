// Demo AuthService - Sin Firebase para funcionamiento demo

class DemoUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;

  DemoUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  DemoUser? _currentUser;
  
  // Usuarios demo predefinidos
  final Map<String, String> _demoUsers = {
    'admin@roflix.com': '123456',
    'user@roflix.com': 'password',
    'demo@gmail.com': 'demo123',
    'test@test.com': 'test123',
  };
  
  // Stream simulado para cambios de estado de autenticación
  Stream<DemoUser?> get authStateChanges {
    return Stream.value(_currentUser);
  }

  // Usuario actual
  DemoUser? get currentUser => _currentUser;

  // Verificar si está autenticado
  bool get isAuthenticated => _currentUser != null;

  // Simulación de login con email y contraseña
  Future<DemoUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Simulación de delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // Validaciones básicas
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email y contraseña son requeridos');
      }
      
      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }
      
      // Verificar credenciales con usuarios demo
      if (!_demoUsers.containsKey(email)) {
        throw Exception('Usuario no encontrado');
      }
      
      if (_demoUsers[email] != password) {
        throw Exception('Contraseña incorrecta');
      }
      
      // Crear usuario demo
      _currentUser = DemoUser(
        uid: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: email.split('@')[0],
      );
      
      return _currentUser;
    } catch (e) {
      throw Exception('Error de inicio de sesión: ${e.toString()}');
    }
  }

  // Simulación de registro con email y contraseña
  Future<DemoUser?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Simulación de delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // Validaciones
      if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
        throw Exception('Todos los campos son requeridos');
      }
      
      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }
      
      if (password.length < 6) {
        throw Exception('La contraseña debe tener al menos 6 caracteres');
      }
      
      // Crear usuario demo
      _currentUser = DemoUser(
        uid: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: displayName,
      );
      
      return _currentUser;
    } catch (e) {
      throw Exception('Error de registro: ${e.toString()}');
    }
  }

  // Simulación de login con Google
  Future<DemoUser?> signInWithGoogle() async {
    try {
      // Simulación de delay de Google Sign In
      await Future.delayed(const Duration(seconds: 2));
      
      // Crear usuario demo con datos de Google
      _currentUser = DemoUser(
        uid: 'google_demo_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'demo.google@gmail.com',
        displayName: 'Usuario Google Demo',
        photoURL: 'https://picsum.photos/150/150?random=999',
      );
      
      return _currentUser;
    } catch (e) {
      throw Exception('Error de inicio de sesión con Google: ${e.toString()}');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  // Eliminar cuenta
  Future<void> deleteAccount() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = null;
    } catch (e) {
      throw Exception('Error al eliminar cuenta: ${e.toString()}');
    }
  }

  // Restablecer contraseña
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }
      
      // En una app real, esto enviaría un email
      // Email de restablecimiento enviado a: $email (modo demo)
    } catch (e) {
      throw Exception('Error al enviar email: ${e.toString()}');
    }
  }

  // Actualizar perfil
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (_currentUser != null) {
        _currentUser = DemoUser(
          uid: _currentUser!.uid,
          email: _currentUser!.email,
          displayName: displayName ?? _currentUser!.displayName,
          photoURL: photoURL ?? _currentUser!.photoURL,
        );
      }
    } catch (e) {
      throw Exception('Error al actualizar perfil: ${e.toString()}');
    }
  }

  // Obtener ID del usuario
  String? get currentUserId => _currentUser?.uid;

  // Verificar email
  Future<void> sendEmailVerification() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Email de verificación enviado (modo demo)
  }

  // Cambiar contraseña
  Future<void> updatePassword(String newPassword) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (newPassword.length < 6) {
        throw Exception('La contraseña debe tener al menos 6 caracteres');
      }
      
      // Contraseña actualizada correctamente (modo demo)
    } catch (e) {
      throw Exception('Error al cambiar contraseña: ${e.toString()}');
    }
  }
}
