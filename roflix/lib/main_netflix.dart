import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const RoflixApp());
}

class RoflixApp extends StatelessWidget {
  const RoflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROFLIX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFE50914),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          secondary: Color(0xFFB81D24),
          surface: Color(0xFF000000),
          surfaceContainer: Color(0xFF141414),
          onSurface: Color(0xFFB3B3B3),
          onSurfaceVariant: Color(0xFF808080),
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      home: const LoginScreen(),
    );
  }
}

// Pantalla de Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Usuarios demo predefinidos
  final Map<String, String> _demoUsers = {
    'admin@roflix.com': '123456',
    'user@roflix.com': 'password',
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      
      if (!_demoUsers.containsKey(email)) {
        throw Exception('Usuario no encontrado');
      }
      
      if (_demoUsers[email] != password) {
        throw Exception('Contraseña incorrecta');
      }
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(userEmail: _emailController.text.trim()),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: const Color(0xFFE50914),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Logo y título
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'ROFLIX',
                            style: GoogleFonts.inter(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFE50914),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Inicia sesión en tu cuenta',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Campo de email
                    Text(
                      'Email',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'tu@email.com',
                        hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
                        filled: true,
                        fillColor: const Color(0xFF333333),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE50914),
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Por favor ingresa un email válido';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Campo de contraseña
                    Text(
                      'Contraseña',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Tu contraseña',
                        hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
                        filled: true,
                        fillColor: const Color(0xFF333333),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE50914),
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu contraseña';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Botón de iniciar sesión
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Iniciar Sesión',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Usuarios demo disponibles
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1a1a1a),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade800),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuarios Demo Disponibles:',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFE50914),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...[
                            {'email': 'admin@roflix.com', 'password': '123456'},
                            {'email': 'user@roflix.com', 'password': 'password'},
                          ].map((user) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '📧 ${user['email']}',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey[300],
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '🔑 ${user['password']}',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _emailController.text = user['email']!;
                                    _passwordController.text = user['password']!;
                                  },
                                  child: Text(
                                    'Usar',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFE50914),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String userEmail;
  const MainScreen({super.key, required this.userEmail});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          const HomeScreen(),
          const SearchScreen(),
          const DownloadsScreen(),
          ProfileScreen(userEmail: widget.userEmail),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF000000),
          border: Border(
            top: BorderSide(
              color: Color(0xFF333333),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFFE50914),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Color(0xFFB3B3B3)),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: Color(0xFFB3B3B3)),
              selectedIcon: Icon(Icons.search, color: Colors.white),
              label: 'Buscar',
            ),
            NavigationDestination(
              icon: Icon(Icons.download_outlined, color: Color(0xFFB3B3B3)),
              selectedIcon: Icon(Icons.download, color: Colors.white),
              label: 'Descargas',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Color(0xFFB3B3B3)),
              selectedIcon: Icon(Icons.person, color: Colors.white),
              label: 'Mi Netflix',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Listas de contenido para cada sección
  static const List<Map<String, String>> popularMovies = [
    {'title': 'Avatar: El camino del agua', 'match': '98', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg', 'trailer': 'https://www.youtube.com/watch?v=d9MyW72ELq0'},
    {'title': 'Top Gun: Maverick', 'match': '96', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg', 'trailer': 'https://www.youtube.com/watch?v=qSqVVswa420'},
    {'title': 'Spider-Man: No Way Home', 'match': '94', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg', 'trailer': 'https://www.youtube.com/watch?v=JfVOs4VSpmA'},
    {'title': 'Dune', 'match': '92', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg', 'trailer': 'https://www.youtube.com/watch?v=8g18jFHCLXk'},
    {'title': 'No Time to Die', 'match': '90', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/iUgygt3fscRoKWCV1d0C7FbM9TP.jpg', 'trailer': 'https://www.youtube.com/watch?v=BIhNsAtPbPI'},
    {'title': 'The Batman', 'match': '95', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/b0PlSFdDwbyK0cf5RxwDpaOJQvQ.jpg', 'trailer': 'https://www.youtube.com/watch?v=mqqft2x_Aa4'},
    {'title': 'Doctor Strange 2', 'match': '88', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg', 'trailer': 'https://www.youtube.com/watch?v=aWzlQ2N6qqg'},
    {'title': 'Black Panther 2', 'match': '93', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/sv1xJUazXeYqALzczSZ3O6nkH75.jpg', 'trailer': 'https://www.youtube.com/watch?v=_Z3QKkl1WyM'},
    {'title': 'Thor: Love and Thunder', 'match': '86', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg', 'trailer': 'https://www.youtube.com/watch?v=Go8nTmfrQd8'},
    {'title': 'Minions: El origen de Gru', 'match': '91', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/wKiOkZTN9lUUUNZLmtnwubZYONg.jpg', 'trailer': 'https://www.youtube.com/watch?v=xEalpbL1iQI'},
  ];

  static const List<Map<String, String>> trendingSeries = [
    {'title': 'Stranger Things', 'match': '97', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/49WJfeN0moxb9IPfGn8AIqMGskD.jpg', 'trailer': 'https://www.youtube.com/watch?v=b9EkMc79ZSU'},
    {'title': 'Wednesday', 'match': '95', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/9PFonBhy4cQy7Jz20NpMygczOkv.jpg', 'trailer': 'https://www.youtube.com/watch?v=Di310WS8zLk'},
    {'title': 'The Crown', 'match': '93', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/1M876KPjulVwppEpldhdc8V4o68.jpg', 'trailer': 'https://www.youtube.com/watch?v=JWtnJjn6ng0'},
    {'title': 'Ozark', 'match': '91', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/m73QxaOBNe6ZPCBMVQQnw9tA3kq.jpg', 'trailer': 'https://www.youtube.com/watch?v=5hAXVqrljbs'},
    {'title': 'Squid Game', 'match': '96', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg', 'trailer': 'https://www.youtube.com/watch?v=oqxAJKy0ii4'},
    {'title': 'Euphoria', 'match': '89', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/jtnfNzqZwN4E32FGGxx1YZaBWWf.jpg', 'trailer': 'https://www.youtube.com/watch?v=javY5mSGC-8'},
    {'title': 'Breaking Bad', 'match': '99', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/ggFHVNu6YYI5L9pCfOacjizRGt.jpg', 'trailer': 'https://www.youtube.com/watch?v=HhesaQXLuRY'},
    {'title': 'The Witcher', 'match': '87', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/cZ0d3rtvXPVvuiX22sP79K3Hmjz.jpg', 'trailer': 'https://www.youtube.com/watch?v=ndl1W4ltcmg'},
    {'title': 'Money Heist', 'match': '92', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg', 'trailer': 'https://www.youtube.com/watch?v=_InqQJRqGW4'},
    {'title': 'Dark', 'match': '94', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/56v2KjBlU4XaOv9rVYEQypROD7P.jpg', 'trailer': 'https://www.youtube.com/watch?v=rrwycJ08PSA'},
  ];

  static const List<Map<String, String>> myListContent = [
    {'title': 'The Queen\'s Gambit', 'match': '96', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/zU0htwkhNvBQdVSIKB9s6hgVeFK.jpg', 'trailer': 'https://www.youtube.com/watch?v=CDrieqwSdgI'},
    {'title': 'Inception', 'match': '94', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg', 'trailer': 'https://www.youtube.com/watch?v=YoHD9XEInc0'},
    {'title': 'Interstellar', 'match': '95', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg', 'trailer': 'https://www.youtube.com/watch?v=zSWdZVtXT7E'},
    {'title': 'The Office', 'match': '92', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/7DJKHzAi83BmQrWLrYYOqcoKfhR.jpg', 'trailer': 'https://www.youtube.com/watch?v=LHOtME2DL4g'},
    {'title': 'Friends', 'match': '90', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/f496cm9enuEsZkSPzCwnTESEK5s.jpg', 'trailer': 'https://www.youtube.com/watch?v=hDNNmeeJs1Q'},
    {'title': 'Game of Thrones', 'match': '93', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg', 'trailer': 'https://www.youtube.com/watch?v=rlR4PJn8b8I'},
    {'title': 'The Mandalorian', 'match': '89', 'type': 'Serie', 'image': 'https://image.tmdb.org/t/p/w500/sWgBv7LV2PRoQgkxwlibdGXKz1S.jpg', 'trailer': 'https://www.youtube.com/watch?v=aOC8E8z_ifw'},
    {'title': 'Pulp Fiction', 'match': '97', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg', 'trailer': 'https://www.youtube.com/watch?v=s7EdQ4FqbhY'},
    {'title': 'The Godfather', 'match': '98', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg', 'trailer': 'https://www.youtube.com/watch?v=sY1S34973zA'},
    {'title': 'Forrest Gump', 'match': '91', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg', 'trailer': 'https://www.youtube.com/watch?v=bLvqoHBptjg'},
  ];

  static const List<Map<String, String>> newReleases = [
    {'title': 'Glass Onion', 'match': '88', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/vDGr1YdrlfbU9wxTOdpf3zChmv9.jpg', 'trailer': 'https://www.youtube.com/watch?v=gj3HZKawmCk'},
    {'title': 'Enola Holmes 2', 'match': '86', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/tegBpjM5ODoYoM1NjaiHVLEA0QM.jpg', 'trailer': 'https://www.youtube.com/watch?v=ceAbyAZxP-Y'},
    {'title': 'The Gray Man', 'match': '84', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/5MlbFjjXxN2TQ0iyXpZL9aBtKJ8.jpg', 'trailer': 'https://www.youtube.com/watch?v=BmllggGO4pM'},
    {'title': 'Red Notice', 'match': '82', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/lAXONuqg41NwUMuzMiFvicDET9F.jpg', 'trailer': 'https://www.youtube.com/watch?v=Pj0wz7zu3Ms'},
    {'title': 'Don\'t Look Up', 'match': '85', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/th4E1yqsE8DGpAseLiUrI60Hf8V.jpg', 'trailer': 'https://www.youtube.com/watch?v=RbIxYm3mKzI'},
    {'title': 'The Adam Project', 'match': '83', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/wFjboE0aFZNbVOF05fzrka9Fqyx.jpg', 'trailer': 'https://www.youtube.com/watch?v=DE3MdRfCPR4'},
    {'title': 'Hustle', 'match': '87', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/zTrh0ysIxNSNupNAJV0KxcOEwGr.jpg', 'trailer': 'https://www.youtube.com/watch?v=lQ7_qI3dR1w'},
    {'title': 'The Sea Beast', 'match': '89', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/9Vw10h9IDyfEQO8bm8ZlWaXHctm.jpg', 'trailer': 'https://www.youtube.com/watch?v=9VlalNbUBiE'},
    {'title': 'Purple Hearts', 'match': '81', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/4JyNWkryifWbWXJyxcWh3pVya6N.jpg', 'trailer': 'https://www.youtube.com/watch?v=5G9O8aU0w5g'},
    {'title': 'Spiderhead', 'match': '80', 'type': 'Película', 'image': 'https://image.tmdb.org/t/p/w500/7VaGxLwX3p7vAmF0OKFm8NFXW7h.jpg', 'trailer': 'https://www.youtube.com/watch?v=Fi8RsU-GB74'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header estilo Netflix
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF000000),
                ),
                child: Row(
                  children: [
                    Text(
                      'ROFLIX',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFE50914),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Row(
                        children: [
                          _buildNavItem(context, 'Inicio'),
                          _buildNavItem(context, 'Series'),
                          _buildNavItem(context, 'Películas'),
                          _buildNavItem(context, 'Novedades'),
                          _buildNavItem(context, 'Mi lista'),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SearchScreen()),
                            );
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                            );
                          },
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Botón de perfil - solo decorativo ya que se accede desde la navegación principal
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE50914),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Hero principal estilo Netflix
              Container(
                height: 400,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Color(0x88000000),
                        Color(0xFF000000),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE50914),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'N',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Stranger Things',
                          style: GoogleFonts.inter(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cuando un niño desaparece, un pequeño pueblo descubre un misterio que involucra experimentos secretos.',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('▶️ Reproduciendo...'),
                                      backgroundColor: Color(0xFF333333),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.play_arrow, size: 24),
                                label: Text(
                                  'Reproducir',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('➕ Agregado a Mi Lista'),
                                      backgroundColor: Color(0xFF333333),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF333333),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.add, size: 24),
                                label: Text(
                                  'Mi lista',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ℹ️ Más información'),
                                      backgroundColor: Color(0xFF333333),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF333333),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.info_outline, size: 24),
                                label: Text(
                                  'Más información',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Secciones de películas estilo Netflix
              _buildMovieSection(context, 'Populares en ROFLIX', popularMovies),
              const SizedBox(height: 24),
              _buildMovieSection(context, 'Tendencias ahora', trendingSeries),
              const SizedBox(height: 24),
              _buildMovieSection(context, 'Mi lista', myListContent),
              const SizedBox(height: 24),
              _buildMovieSection(context, 'Nuevos lanzamientos', newReleases),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          switch (title) {
            case 'Inicio':
              break;
            case 'Series':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SeriesScreen()),
              );
              break;
            case 'Películas':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoviesScreen()),
              );
              break;
            case 'Novedades':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewReleasesScreen()),
              );
              break;
            case 'Mi lista':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyListScreen()),
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Navegando a $title'),
                  backgroundColor: const Color(0xFFE50914),
                ),
              );
          }
        },
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieSection(BuildContext context, String title, List<Map<String, String>> content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: content.length,
              itemBuilder: (context, index) {
                final item = content[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentDetailScreen(content: item),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // Imagen de fondo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item['image'] != null
                              ? Image.network(
                                  item['image']!,
                                  width: 140,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 140,
                                      height: 200,
                                      color: const Color(0xFF333333),
                                      child: const Icon(
                                        Icons.movie,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 140,
                                      height: 200,
                                      color: const Color(0xFF333333),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFE50914),
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 140,
                                  height: 200,
                                  color: const Color(0xFF333333),
                                  child: const Icon(
                                    Icons.movie,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                        ),
                        // Gradiente superpuesto
                        Container(
                          width: 140,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Color(0x66000000),
                                Color(0xFF000000),
                              ],
                            ),
                          ),
                        ),
                        // Contenido superpuesto
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['title'] ?? 'Sin título',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF46D369),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '${item['match']}% coincidencia',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: const Color(0xFF46D369),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['type'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: const Color(0xFFB3B3B3),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Pantallas simplificadas sin dependencias externas
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Buscar',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _controller,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar películas, series, actores...',
                  hintStyle: GoogleFonts.inter(color: const Color(0xFFB3B3B3)),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFB3B3B3)),
                ),
                onChanged: (value) {
                  setState(() {
                    _isSearching = value.isNotEmpty;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _isSearching 
                  ? const Center(
                      child: Text(
                        'Resultados de búsqueda aparecerán aquí',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Busca tu contenido favorito',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mis Descargas',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Expanded(
                child: Center(
                  child: Text(
                    'No tienes descargas aún',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userEmail;
  const ProfileScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50914),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userEmail == 'admin@roflix.com' ? 'Administrador' : 'Usuario',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userEmail,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFFB3B3B3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Solo mostrar el botón "Agregar Película" si es admin
              if (userEmail == 'admin@roflix.com')
                _buildOptionTile(
                  context,
                  'Agregar Película/Serie',
                  'Añade nuevo contenido a la plataforma',
                  Icons.add_circle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddMovieScreen(),
                      ),
                    );
                  },
                ),
              _buildOptionTile(
                context,
                'Configuración',
                'Personaliza tu experiencia',
                Icons.settings,
              ),
              _buildOptionTile(
                context,
                'Notificaciones',
                'Gestiona tus alertas',
                Icons.notifications,
              ),
              _buildOptionTile(
                context,
                'Ayuda y Soporte',
                'Obtén ayuda cuando la necesites',
                Icons.help,
              ),
              _buildOptionTile(
                context,
                'Acerca de',
                'Información de la app',
                Icons.info,
              ),
              _buildOptionTile(
                context,
                'Cerrar Sesión',
                'Salir de tu cuenta',
                Icons.logout,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(
          icon,
          color: isDestructive ? const Color(0xFFE50914) : Colors.white,
          size: 24,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? const Color(0xFFE50914) : Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFFB3B3B3),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFB3B3B3),
          size: 16,
        ),
        onTap: onTap ?? () {
          _handleProfileOptionTap(context, title);
        },
      ),
    );
  }

  void _handleProfileOptionTap(BuildContext context, String title) {
    switch (title) {
      case 'Configuración':
        _showSettingsDialog(context);
        break;
      case 'Notificaciones':
        _showNotificationsDialog(context);
        break;
      case 'Ayuda y Soporte':
        _showHelpDialog(context);
        break;
      case 'Acerca de':
        _showAboutDialog(context);
        break;
      case 'Cerrar Sesión':
        _showLogoutDialog(context);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title - Funcionalidad disponible'),
            backgroundColor: const Color(0xFFE50914),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            'Configuración',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode, color: Colors.white),
                title: Text('Modo oscuro', style: GoogleFonts.inter(color: Colors.white)),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: const Color(0xFFE50914),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                title: Text('Notificaciones push', style: GoogleFonts.inter(color: Colors.white)),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: const Color(0xFFE50914),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.download, color: Colors.white),
                title: Text('Descargas automáticas', style: GoogleFonts.inter(color: Colors.white)),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeColor: const Color(0xFFE50914),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: GoogleFonts.inter(color: const Color(0xFFE50914)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            'Notificaciones',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gestiona tus alertas y notificaciones:',
                style: GoogleFonts.inter(color: const Color(0xFFB3B3B3)),
              ),
              const SizedBox(height: 16),
              _buildNotificationOption('Nuevos lanzamientos', true),
              _buildNotificationOption('Recomendaciones personalizadas', true),
              _buildNotificationOption('Actualizaciones de la app', false),
              _buildNotificationOption('Ofertas especiales', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Guardar',
                style: GoogleFonts.inter(color: const Color(0xFFE50914)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationOption(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {},
            activeColor: const Color(0xFFE50914),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            'Ayuda y Soporte',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpOption(Icons.chat, 'Chat en vivo', '24/7 disponible'),
              _buildHelpOption(Icons.email, 'Enviar email', 'soporte@roflix.com'),
              _buildHelpOption(Icons.phone, 'Llamar', '+1 (555) 123-4567'),
              _buildHelpOption(Icons.help_outline, 'Preguntas frecuentes', 'Ver FAQ'),
              _buildHelpOption(Icons.bug_report, 'Reportar problema', 'Informar bug'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: GoogleFonts.inter(color: const Color(0xFFE50914)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpOption(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE50914), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(color: const Color(0xFFB3B3B3), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            'Acerca de ROFLIX',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'ROFLIX',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFE50914),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Versión: 1.0.0',
                style: GoogleFonts.inter(color: const Color(0xFFB3B3B3)),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu plataforma de streaming favorita con miles de películas y series.',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                '© 2025 ROFLIX. Todos los derechos reservados.',
                style: GoogleFonts.inter(color: const Color(0xFFB3B3B3), fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: GoogleFonts.inter(color: const Color(0xFFE50914)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            'Cerrar Sesión',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: GoogleFonts.inter(color: const Color(0xFFB3B3B3)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(color: const Color(0xFFB3B3B3)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión cerrada exitosamente'),
                    backgroundColor: Color(0xFFE50914),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Cerrar Sesión',
                style: GoogleFonts.inter(color: const Color(0xFFE50914)),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Pantallas adicionales con contenido específico
class SeriesScreen extends StatelessWidget {
  const SeriesScreen({super.key});

  // Lista de series exclusivas
  static const List<Map<String, String>> seriesList = [
    {'title': 'Stranger Things', 'match': '97', 'seasons': '4 temporadas', 'image': 'https://image.tmdb.org/t/p/w500/49WJfeN0moxb9IPfGn8AIqMGskD.jpg', 'trailer': 'https://www.youtube.com/watch?v=b9EkMc79ZSU'},
    {'title': 'The Crown', 'match': '95', 'seasons': '6 temporadas', 'image': 'https://image.tmdb.org/t/p/w500/1M876KPjulVwppEpldhdc8V4o68.jpg', 'trailer': 'https://www.youtube.com/watch?v=JWtnJjn6ng0'},
    {'title': 'Ozark', 'match': '93', 'seasons': '4 temporadas', 'image': 'https://image.tmdb.org/t/p/w500/m73QxaOBNe6ZPCBMVQQnw9tA3kq.jpg', 'trailer': 'https://www.youtube.com/watch?v=5hAXVqrljbs'},
    {'title': 'Wednesday', 'match': '91', 'seasons': '1 temporada', 'image': 'https://image.tmdb.org/t/p/w500/9PFonBhy4cQy7Jz20NpMygczOkv.jpg', 'trailer': 'https://www.youtube.com/watch?v=Di310WS8zLk'},
    {'title': 'Squid Game', 'match': '96', 'seasons': '2 temporadas', 'image': 'https://image.tmdb.org/t/p/w500/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg', 'trailer': 'https://www.youtube.com/watch?v=oqxAJKy0ii4'},
    {'title': 'Euphoria', 'match': '89', 'seasons': '2 temporadas', 'image': 'https://image.tmdb.org/t/p/w500/jtnfNzqZwN4E32FGGxx1YZaBWWf.jpg', 'trailer': 'https://www.youtube.com/watch?v=javY5mSGC-8'},
    {'title': 'The Witcher', 'match': '87', 'seasons': '3 temporadas', 'image': 'https://image.tmdb.org/t/p/w500/cZ0d3rtvXPVvuiX22sP79K3Hmjz.jpg', 'trailer': 'https://www.youtube.com/watch?v=ndl1W4ltcmg'},
    {'title': 'Money Heist', 'match': '92', 'seasons': '5 temporadas', 'image': 'https://image.tmdb.org/t/p/w500/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg', 'trailer': 'https://www.youtube.com/watch?v=_InqQJRqGW4'},
    {'title': 'Dark', 'match': '94', 'seasons': '3 temporadas', 'image': 'https://image.tmdb.org/t/p/w500/56v2KjBlU4XaOv9rVYEQypROD7P.jpg', 'trailer': 'https://www.youtube.com/watch?v=rrwycJ08PSA'},
    {'title': 'Breaking Bad', 'match': '99', 'seasons': '5 temporadas', 'image': 'https://image.tmdb.org/t/p/w500/ggFHVNu6YYI5L9pCfOacjizRGt.jpg', 'trailer': 'https://www.youtube.com/watch?v=HhesaQXLuRY'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Series',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Las mejores series de ROFLIX',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: seriesList.length,
              itemBuilder: (context, index) {
                final series = seriesList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentDetailScreen(content: series),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                series['image'] != null
                                    ? Image.network(
                                        series['image']!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: const Color(0xFF555555),
                                            child: const Center(
                                              child: Icon(
                                                Icons.play_circle_outline,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: const Color(0xFF555555),
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xFFE50914),
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: const Color(0xFF555555),
                                        child: const Center(
                                          child: Icon(
                                            Icons.play_circle_outline,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                // Overlay de play button
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.3),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  series['title'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  series['seasons'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFFB3B3B3),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${series['match']}% coincidencia',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: const Color(0xFF46D369),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  // Lista de películas exclusivas
  static const List<Map<String, String>> moviesList = [
    {'title': 'Avatar: El camino del agua', 'match': '98', 'year': '2022', 'trailer': 'https://www.youtube.com/watch?v=d9MyW72ELq0'},
    {'title': 'Top Gun: Maverick', 'match': '96', 'year': '2022', 'trailer': 'https://www.youtube.com/watch?v=qSqVVswa420'},
    {'title': 'Spider-Man: No Way Home', 'match': '94', 'year': '2021', 'trailer': 'https://www.youtube.com/watch?v=JfVOs4VSpmA'},
    {'title': 'Dune', 'match': '92', 'year': '2021', 'trailer': 'https://www.youtube.com/watch?v=8g18jFHCLXk'},
    {'title': 'The Batman', 'match': '95', 'year': '2022', 'trailer': 'https://www.youtube.com/watch?v=mqqft2x_Aa4'},
    {'title': 'Doctor Strange 2', 'match': '88', 'year': '2022', 'trailer': 'https://www.youtube.com/watch?v=aWzlQ2N6qqg'},
    {'title': 'Black Panther 2', 'match': '93', 'year': '2022', 'trailer': 'https://www.youtube.com/watch?v=_Z3QKkl1WyM'},
    {'title': 'Thor: Love and Thunder', 'match': '86', 'year': '2022', 'trailer': 'https://www.youtube.com/watch?v=Go8nTmfrQd8'},
    {'title': 'Lightyear', 'match': '84', 'year': '2022', 'trailer': 'https://www.youtube.com/watch?v=BwZs3H_UN3k'},
    {'title': 'Jurassic World 3', 'match': '82', 'year': '2022', 'trailer': 'https://www.youtube.com/watch?v=fb5ELWi-ekk'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Películas',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blockbusters en ROFLIX',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: moviesList.length,
              itemBuilder: (context, index) {
                final movie = moviesList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentDetailScreen(content: movie),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF555555),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF777777),
                                  Color(0xFF333333),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.movie_outlined,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  movie['title'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      movie['year'] ?? '',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: const Color(0xFFB3B3B3),
                                      ),
                                    ),
                                    Text(
                                      '${movie['match']}%',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: const Color(0xFF46D369),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewReleasesScreen extends StatelessWidget {
  const NewReleasesScreen({super.key});

  // Lista de novedades y nuevos lanzamientos
  static const List<Map<String, String>> newReleasesList = [
    {'title': 'Glass Onion: A Knives Out Mystery', 'match': '88', 'date': 'Dic 2024'},
    {'title': 'Enola Holmes 2', 'match': '86', 'date': 'Nov 2024'},
    {'title': 'The Gray Man', 'match': '84', 'date': 'Nov 2024'},
    {'title': 'Red Notice 2', 'match': '82', 'date': 'Oct 2024'},
    {'title': 'The Adam Project 2', 'match': '85', 'date': 'Oct 2024'},
    {'title': 'Hustle Time', 'match': '87', 'date': 'Sep 2024'},
    {'title': 'The Sea Beast 2', 'match': '89', 'date': 'Sep 2024'},
    {'title': 'Purple Hearts 2', 'match': '81', 'date': 'Ago 2024'},
    {'title': 'Spiderhead Reloaded', 'match': '80', 'date': 'Ago 2024'},
    {'title': 'The Night Agent 2', 'match': '92', 'date': 'Jul 2024'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Novedades',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE50914),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.new_releases, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Últimos estrenos de ROFLIX',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: newReleasesList.length,
              itemBuilder: (context, index) {
                final release = newReleasesList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    tileColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF555555),
                            Color(0xFF333333),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      release['title'] ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Nuevo • ${release['date']}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFFB3B3B3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF46D369),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${release['match']}% coincidencia',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF46D369),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reproduciendo: ${release['title']}'),
                          backgroundColor: const Color(0xFFE50914),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  // Lista personalizada del usuario
  static const List<Map<String, String>> myPersonalList = [
    {'title': 'The Queen\'s Gambit', 'match': '96', 'type': 'Serie • Drama'},
    {'title': 'Inception', 'match': '94', 'type': 'Película • Sci-Fi'},
    {'title': 'Interstellar', 'match': '95', 'type': 'Película • Drama'},
    {'title': 'The Office', 'match': '92', 'type': 'Serie • Comedia'},
    {'title': 'Friends', 'match': '90', 'type': 'Serie • Comedia'},
    {'title': 'Game of Thrones', 'match': '93', 'type': 'Serie • Fantasía'},
    {'title': 'The Mandalorian', 'match': '89', 'type': 'Serie • Sci-Fi'},
    {'title': 'Pulp Fiction', 'match': '97', 'type': 'Película • Thriller'},
    {'title': 'The Godfather', 'match': '98', 'type': 'Película • Drama'},
    {'title': 'Forrest Gump', 'match': '91', 'type': 'Película • Drama'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Mi Lista',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de edición próximamente'),
                  backgroundColor: Color(0xFFE50914),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE50914),
                    Color(0xFFB81D24),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tu contenido favorito',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${myPersonalList.length} elementos guardados',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tus guardados',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myPersonalList.length,
              itemBuilder: (context, index) {
                final item = myPersonalList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    tileColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF555555),
                            Color(0xFF333333),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      item['title'] ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item['type'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFFB3B3B3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF46D369),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${item['match']}% coincidencia',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF46D369),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.download_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Descargando: ${item['title']}'),
                                backgroundColor: const Color(0xFF333333),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Color(0xFFE50914),
                            size: 20,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item['title']} eliminado de Mi Lista'),
                                backgroundColor: const Color(0xFFE50914),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reproduciendo: ${item['title']}'),
                          backgroundColor: const Color(0xFFE50914),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Función para abrir URLs de YouTube
Future<void> _launchYouTube(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'No se pudo abrir el enlace: $url';
  }
}

class ContentDetailScreen extends StatelessWidget {
  final Map<String, String> content;

  const ContentDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF000000),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen de fondo
                  content['image'] != null
                      ? Image.network(
                          content['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF333333),
                              child: const Icon(
                                Icons.movie,
                                color: Colors.white,
                                size: 80,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFF333333),
                          child: const Icon(
                            Icons.movie,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                  // Gradiente
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          const Color(0xFF000000).withValues(alpha: 0.7),
                          const Color(0xFF000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    content['title'] ?? 'Sin título',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Año y tipo
                  Row(
                    children: [
                      Text(
                        content['year'] ?? '2024',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE50914),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          content['type'] ?? 'Película',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reproduciendo: ${content['title']}'),
                                backgroundColor: const Color(0xFFE50914),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow, color: Colors.black),
                          label: Text(
                            'Reproducir',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Agregado a Mi Lista'),
                                backgroundColor: Color(0xFFE50914),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            'Mi Lista',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF333333),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Botón de tráiler
                  if (content['trailer'] != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await _launchYouTube(content['trailer']!);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al abrir el tráiler'),
                                  backgroundColor: Color(0xFFE50914),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.play_circle_outline, color: Colors.white),
                        label: Text(
                          'Ver Tráiler',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  
                  // Descripción
                  Text(
                    'Sinopsis',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Una increíble historia que te mantendrá al borde de tu asiento. Con actuaciones excepcionales y una trama cautivadora, esta es una experiencia cinematográfica que no puedes perderte.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[300],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Información adicional
                  Text(
                    'Detalles',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Género', 'Acción, Drama, Thriller'),
                  _buildDetailRow('Duración', '2h 15min'),
                  _buildDetailRow('Clasificación', 'PG-13'),
                  _buildDetailRow('Director', 'Nombre del Director'),
                  _buildDetailRow('Reparto', 'Actor 1, Actor 2, Actor 3'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Notificaciones',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Notificaciones - Próximamente contenido completo',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _yearController = TextEditingController();
  final _durationController = TextEditingController();
  final _ratingController = TextEditingController();
  
  String _selectedCategory = 'Película';
  String _selectedGenre = 'Acción';
  bool _isLoading = false;

  final List<String> _categories = ['Película', 'Serie', 'Documental'];
  final List<String> _genres = [
    'Acción', 'Aventura', 'Animación', 'Comedia', 'Drama', 'Fantasía', 
    'Horror', 'Romance', 'Sci-Fi', 'Thriller'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _yearController.dispose();
    _durationController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveMovie() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_selectedCategory "${_titleController.text}" agregada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agregar ${_selectedCategory.toLowerCase()}: $e'),
            backgroundColor: const Color(0xFFE50914),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _yearController.clear();
    _durationController.clear();
    _ratingController.clear();
    setState(() {
      _selectedCategory = 'Película';
      _selectedGenre = 'Acción';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(
          'Agregar $_selectedCategory',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _clearForm,
            child: Text(
              'Limpiar',
              style: GoogleFonts.inter(
                color: const Color(0xFFE50914),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tipo de contenido
              Text(
                'Tipo de Contenido',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: const Color(0xFF333333),
                  style: GoogleFonts.inter(color: Colors.white),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Título
              _buildTextField('Título', _titleController, 'Ingresa el título'),
              const SizedBox(height: 20),

              // Descripción
              _buildTextField('Descripción', _descriptionController, 'Ingresa una descripción', maxLines: 3),
              const SizedBox(height: 20),

              // URL de imagen
              _buildTextField('URL de Imagen', _imageUrlController, 'https://ejemplo.com/imagen.jpg'),
              const SizedBox(height: 20),

              // Año y duración en fila
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Año', _yearController, '2024', keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Duración', _durationController, '120 min'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Calificación y género
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Calificación (0-10)', _ratingController, '8.5', keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Género',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF333333),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedGenre,
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: const Color(0xFF333333),
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                            items: _genres.map((genre) {
                              return DropdownMenuItem(
                                value: genre,
                                child: Text(genre),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGenre = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Botón de guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSaveMovie,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Agregar $_selectedCategory',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: const Color(0xFF666666)),
            filled: true,
            fillColor: const Color(0xFF333333),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE50914),
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label es requerido';
            }
            return null;
          },
        ),
      ],
    );
  }
}
