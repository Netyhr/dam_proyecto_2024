import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto_2024/services/category_service.dart';
import 'package:dam_proyecto_2024/services/recipe_service.dart';
import 'package:flutter/material.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  String? _selectedCategory;

  final RecipeService _recipeService = RecipeService();
  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Receta'),
        backgroundColor: Colors.green.shade200,
        iconTheme: IconThemeData(color: Colors.brown.shade800),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.yellow.shade50,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el nombre de la receta.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _categoryService.getAllCategories(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Cargando categorías');
                      }

                      final categories = snapshot.data!.docs.map((doc) {
                        return {
                          'id': doc.id,
                          'nombre': doc['nombre'] as String,
                        };
                      }).toList();

                      return DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category['id'],
                            child: Text(category['nombre'].toString()),
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Categoría'),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecciona una categoría.';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: _instructionsController,
                    decoration: InputDecoration(
                      labelText: 'Instrucciones',
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa las instrucciones.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          bool success = await _recipeService.addRecipe(
                              name: _nameController.text.trim(),
                              instructions: _instructionsController.text.trim(),
                              categoryId: _selectedCategory.toString());

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Receta guardada con éxito.'),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Error al guardar la receta. Inténtalo de nuevo.'),
                              backgroundColor: Colors.red,
                            ));
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
