import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final _trailerUrlController = TextEditingController();
  final _yearController = TextEditingController();
  final _durationController = TextEditingController();
  final _ratingController = TextEditingController();
  
  String _selectedCategory = 'Película';
  String _selectedGenre = 'Acción';
  bool _isLoading = false;

  final List<String> _categories = ['Película', 'Serie', 'Documental'];
  final List<String> _genres = [
    'Acción',
    'Aventura',
    'Animación',
    'Biografía',
    'Comedia',
    'Crimen',
    'Documental',
    'Drama',
    'Familia',
    'Fantasía',
    'Historia',
    'Horror',
    'Música',
    'Misterio',
    'Romance',
    'Sci-Fi',
    'Deporte',
    'Thriller',
    'Guerra',
    'Western'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _trailerUrlController.dispose();
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
      // Simular guardado de película
      await Future.delayed(const Duration(seconds: 2));
      
      // Crear el objeto de película
      final newMovie = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
        'trailerUrl': _trailerUrlController.text.trim(),
        'year': int.tryParse(_yearController.text.trim()) ?? 2024,
        'duration': _durationController.text.trim(),
        'rating': double.tryParse(_ratingController.text.trim()) ?? 0.0,
        'category': _selectedCategory,
        'genre': _selectedGenre,
        'createdAt': DateTime.now(),
      };

      // En una app real, aquí se guardaría en la base de datos
      // await movieService.addMovie(newMovie);
      
      debugPrint('Nueva película agregada: ${newMovie['title']}');

      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_selectedCategory "${_titleController.text}" agregada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Limpiar el formulario
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
    _trailerUrlController.clear();
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Agregar $_selectedCategory',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
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
              _buildSectionTitle('Tipo de Contenido'),
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
              _buildTextField(
                'Título',
                _titleController,
                'Ingresa el título',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es requerido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Descripción
              _buildTextField(
                'Descripción',
                _descriptionController,
                'Ingresa una descripción',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es requerida';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // URL de imagen
              _buildTextField(
                'URL de Imagen',
                _imageUrlController,
                'https://ejemplo.com/imagen.jpg',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La URL de imagen es requerida';
                  }
                  if (!Uri.tryParse(value)!.hasAbsolutePath) {
                    return 'Ingresa una URL válida';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // URL del trailer
              _buildTextField(
                'URL del Trailer (Opcional)',
                _trailerUrlController,
                'https://youtube.com/watch?v=...',
              ),

              const SizedBox(height: 24),

              // Año y duración en fila
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Año',
                      _yearController,
                      '2024',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El año es requerido';
                        }
                        final year = int.tryParse(value);
                        if (year == null || year < 1900 || year > 2030) {
                          return 'Año inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Duración',
                      _durationController,
                      '120 min',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La duración es requerida';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Calificación y género en fila
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Calificación (0-10)',
                      _ratingController,
                      '8.5',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La calificación es requerida';
                        }
                        final rating = double.tryParse(value);
                        if (rating == null || rating < 0 || rating > 10) {
                          return 'Calificación inválida (0-10)';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Género'),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
