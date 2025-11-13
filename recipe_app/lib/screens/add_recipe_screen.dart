import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';

class AddRecipeScreen extends StatefulWidget {
  final VoidCallback? onCancel;

  const AddRecipeScreen({super.key, this.onCancel});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _ingredients = [];
  final ImagePicker _picker = ImagePicker();
  int? _selectedHour;
  int? _selectedMinute;

  // pliki zdjęć
  List<File> _selectedFiles = [];         // mobilnie
  List<Uint8List> _selectedFilesWeb = []; // webowo

  // Funkcja do zrobienia zdjęcia
  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedFiles.add(File(image.path)); // mobilnie
        // jeśli web, użyj innego sposobu, np. image.bytes
      });
    }
  }

 // Funkcja wyboru zdjęć
  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          _selectedFilesWeb.addAll(result.files.map((file) => file.bytes!).toList());
        } else {
          _selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
        }
      });
    }
  }

  // Usunięcie miniatury
  void _removeFile(int index) {
    setState(() {
      if (kIsWeb) {
        _selectedFilesWeb.removeAt(index);
      } else {
        _selectedFiles.removeAt(index);
      }
    });
  }

  // Usuwanie danych po przeslaniu lub odrzuceniu nowego przepisu
  void _resetForm() {
    _titleController.clear();
    _ingredientController.clear();
    _descriptionController.clear();
    _ingredients.clear();
    _selectedHour = null;
    _selectedMinute = null;
    _selectedFiles.clear();
    _selectedFilesWeb.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF2D0C57);
    const lightBackground = Color(0xFFFBFBFF);

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        title: Text(
          'Add a recipe',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: primaryPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Ingredients
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredients',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ingredientController,
                          decoration: InputDecoration(
                            labelText: 'Add ingredient',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Add button
                      ElevatedButton(
                        onPressed: () {
                          final ingredient = _ingredientController.text.trim();
                          if (ingredient.isNotEmpty) {
                            setState(() {
                              _ingredients.add(ingredient);
                              _ingredientController.clear();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          elevation: 0,
                          minimumSize: const Size(0, 56),
                        ),
                        child: Text(
                          'Add',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Wyświetlanie dodanych składników
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _ingredients.asMap().entries.map((entry) {
                      final index = entry.key;
                      final ing = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '• $ing',
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _ingredients.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                ],
              ),



              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true, 
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preparation time',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _selectedHour,
                          decoration: InputDecoration(
                            labelText: 'Hours',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: List.generate(
                            24,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text('$index'),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedHour = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _selectedMinute,
                          decoration: InputDecoration(
                            labelText: 'Minutes',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: List.generate(
                            60,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text('$index'),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedMinute = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),


              // Photo upload 
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickFiles,
                      icon: const Icon(Icons.attach_file),
                      label: Text(
                        kIsWeb
                            ? (_selectedFilesWeb.isEmpty
                            ? 'Select photos'
                            : '${_selectedFilesWeb.length} photo(s) selected')
                            : (_selectedFiles.isEmpty
                            ? 'Select photos'
                            : '${_selectedFiles.length} photo(s) selected'),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take photo'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 12),

              // Miniaturki zdjęć
              if ((kIsWeb && _selectedFilesWeb.isNotEmpty) ||
                  (!kIsWeb && _selectedFiles.isNotEmpty))
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: kIsWeb ? _selectedFilesWeb.length : _selectedFiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [

                            // Miniaturka zdjęcia
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: kIsWeb
                                  ? Image.memory(
                                      _selectedFilesWeb[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      _selectedFiles[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),

                          // Przycisk X do usuwania zdjęcia
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  onTap: () => _removeFile(index),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),


              const SizedBox(height: 24),

              // Upload button
              ElevatedButton(
                onPressed: () {
                  _resetForm();
                  widget.onCancel?.call();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: primaryPurple,
                ),
                child: Text(
                  'Upload',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel button
              OutlinedButton(
                onPressed: () {
                  _resetForm();
                  widget.onCancel?.call();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFF2D0C57)), 
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF2D0C57),
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








