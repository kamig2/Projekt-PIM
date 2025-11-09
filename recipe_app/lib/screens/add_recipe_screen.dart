import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _ingredients = [];
  int? _selectedHour;
  int? _selectedMinute;


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
                          //backgroundColor: primaryPurple,
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
                    children: _ingredients
                        .map((ing) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text('• $ing', style: const TextStyle(fontSize: 16)),
                            ))
                        .toList(),
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
                          value: _selectedHour,
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
                          value: _selectedMinute,
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
              OutlinedButton.icon(
                onPressed: () {
                  // wybór pliku
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('File'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              // Upload button
              ElevatedButton(
                onPressed: () {
                  // ...
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
            ],
          ),
        ),
      ),
    );
  }
}
