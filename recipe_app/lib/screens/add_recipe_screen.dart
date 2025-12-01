import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/models/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  final VoidCallback? onCancel;
  final Recipe? recipeToEdit;

  const AddRecipeScreen({super.key, this.onCancel, this.recipeToEdit});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _ingredientController;
  late TextEditingController _descriptionController;
  late TextEditingController _servingsController;
  late TextEditingController _minutesController;

  final List<String> _ingredients = [];
  final ImagePicker _picker = ImagePicker();

  List<File> _selectedFiles = [];
  List<Uint8List> _selectedFilesWeb = [];

  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  // Wydzielona metoda inicjalizacji, aby kod był czystszy
  void _initControllers() {
    _titleController = TextEditingController();
    _ingredientController = TextEditingController();
    _descriptionController = TextEditingController();
    _servingsController = TextEditingController();
    _minutesController = TextEditingController();

    if (widget.recipeToEdit != null) {
      final r = widget.recipeToEdit!;
      _titleController.text = r.title;
      _descriptionController.text = r.description;
      _minutesController.text = r.duration.replaceAll(RegExp(r'[^0-9]'), '');
      _servingsController.text = r.portion.toString();
      _existingImageUrl = r.imageUrl;

      if (r.ingredients.isNotEmpty) {
        _ingredients.addAll(r.ingredients.split(', '));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientController.dispose();
    _descriptionController.dispose();
    _servingsController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  // --- NOWE: FUNKCJA CZYSZCZĄCA FORMULARZ ---
  void _clearForm() {
    _titleController.clear();
    _ingredientController.clear();
    _descriptionController.clear();
    _servingsController.clear();
    _minutesController.clear();
    setState(() {
      _ingredients.clear();
      _selectedFiles.clear();
      _selectedFilesWeb.clear();
      _existingImageUrl = null;
    });
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedFiles.add(File(image.path));
        _existingImageUrl = null;
      });
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true, withData: kIsWeb);
    if (result != null) {
      setState(() {
        if (kIsWeb) {
          _selectedFilesWeb.addAll(result.files.map((file) => file.bytes!).toList());
        } else {
          _selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
        }
        _existingImageUrl = null;
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      if (kIsWeb) {
        _selectedFilesWeb.removeAt(index);
      } else {
        _selectedFiles.removeAt(index);
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one ingredient')));
        return;
      }

      try {
        if (widget.recipeToEdit == null) {
          // TRYB DODAWANIA
          await RecipeService.uploadRecipe(
            title: _titleController.text,
            ingredients: _ingredients.join(', '),
            description: _descriptionController.text,
            preparationTime: int.parse(_minutesController.text),
            portion: int.parse(_servingsController.text),
            files: _selectedFiles,
            filesWeb: _selectedFilesWeb,
          );
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recipe uploaded successfully!')));
        } else {
          // TRYB EDYCJI
          await RecipeService.updateRecipe(
            id: widget.recipeToEdit!.id,
            title: _titleController.text,
            ingredients: _ingredients.join(', '),
            description: _descriptionController.text,
            preparationTime: int.parse(_minutesController.text),
            portion: int.parse(_servingsController.text),
            files: _selectedFiles,
            filesWeb: _selectedFilesWeb,
          );
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recipe updated successfully!')));
        }

        // --- TUTAJ JEST KLUCZOWA ZMIANA ---
        // Czyścimy formularz po sukcesie, zanim przełączymy zakładkę
        _clearForm();

        widget.onCancel?.call();

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF2D0C57);
    final isEditing = widget.recipeToEdit != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Recipe' : 'Add a recipe',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryPurple)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: isEditing ? IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryPurple),
          onPressed: () => Navigator.of(context).pop(),
        ) : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              Row(children: [
                Expanded(child: TextFormField(controller: _ingredientController, decoration: InputDecoration(labelText: 'Ingredient', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white))),
                IconButton(icon: const Icon(Icons.add_circle, color: primaryPurple), onPressed: () {
                  if(_ingredientController.text.isNotEmpty) setState(() { _ingredients.add(_ingredientController.text); _ingredientController.clear(); });
                })
              ]),
              Wrap(spacing: 8, children: _ingredients.map((e) => Chip(label: Text(e), onDeleted: () => setState(() => _ingredients.remove(e)))).toList()),
              const SizedBox(height: 16),

              TextFormField(controller: _descriptionController, maxLines: 3, decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white)),
              const SizedBox(height: 16),

              Row(children: [
                Expanded(child: TextFormField(controller: _servingsController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Servings', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white))),
                const SizedBox(width: 10),
                Expanded(child: TextFormField(controller: _minutesController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Minutes', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white))),
              ]),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(onPressed: _pickFiles, icon: const Icon(Icons.image), label: const Text("Gallery")),
                  OutlinedButton.icon(onPressed: _takePhoto, icon: const Icon(Icons.camera_alt), label: const Text("Camera")),
                ],
              ),

              const SizedBox(height: 10),
              if (isEditing && _existingImageUrl != null && _existingImageUrl!.isNotEmpty && _selectedFiles.isEmpty && _selectedFilesWeb.isEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(_existingImageUrl!, height: 100, width: 100, fit: BoxFit.cover),
                ),

              if (_selectedFiles.isNotEmpty || _selectedFilesWeb.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: kIsWeb ? _selectedFilesWeb.length : _selectedFiles.length,
                      itemBuilder: (context, index) {
                        return Padding(padding: const EdgeInsets.only(right: 8), child: Stack(
                          children: [
                            kIsWeb
                                ? Image.memory(_selectedFilesWeb[index], width: 100, height: 100, fit: BoxFit.cover)
                                : Image.file(_selectedFiles[index], width: 100, height: 100, fit: BoxFit.cover),
                            Positioned(top: 0, right: 0, child: GestureDetector(onTap: () => _removeFile(index), child: const Icon(Icons.cancel, color: Colors.red))),
                          ],
                        ));
                      }
                  ),
                ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: primaryPurple, minimumSize: const Size(double.infinity, 50)),
                child: Text(isEditing ? 'Save Changes' : 'Upload Recipe', style: const TextStyle(color: Colors.white)),
              ),
              if (!isEditing)
                TextButton(
                    onPressed: () {
                      // --- TUTAJ TEŻ CZYŚCIMY ---
                      _clearForm();
                      widget.onCancel?.call();
                    },
                    child: const Text("Cancel")
                ),
            ],
          ),
        ),
      ),
    );
  }
}