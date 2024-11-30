// lib/pages/recipes_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../services/recipe_service.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  bool _showOnlyMyRecipes = false;
  final RecipeService _recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Mis recetas',
                style: TextStyle(
                  color: Colors.brown.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: _showOnlyMyRecipes,
                onChanged: (value) {
                  setState(() {
                    _showOnlyMyRecipes = value;
                  });
                },
                inactiveThumbColor: Colors.brown.shade200,
                activeColor: Colors.redAccent,
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _showOnlyMyRecipes
                ? _recipeService.getUserRecipes()
                : _recipeService.getAllRecipes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar las recetas',
                    style: TextStyle(color: Colors.brown.shade800),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final recipes = snapshot.data?.docs ?? [];

              if (recipes.isEmpty) {
                return Center(
                  child: Text(
                    _showOnlyMyRecipes
                        ? 'No tienes recetas guardadas'
                        : 'No hay recetas disponibles',
                    style: TextStyle(color: Colors.brown.shade800),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index].data() as Map<String, dynamic>;

                  return FutureBuilder<DocumentSnapshot>(
                    future: _recipeService.getUserById(recipe['autor']),
                    builder: (context, authorSnapshot) {
                      final authorName = authorSnapshot.data?.get('nombre') ??
                          'Usuario desconocido';
                      return FutureBuilder(
                        future:
                            _recipeService.getCategoryById(recipe['categoria']),
                        builder: (context, categorySnapshot) {
                          final categoryImage =
                              categorySnapshot.data?.get('foto') ?? 'none';
                          final categoryName =
                              categorySnapshot.data?.get('nombre') ??
                                  'Categoría desconocida';

                          return RecipeCard(
                            recipe: recipe,
                            authorName: authorName,
                            categoryName: categoryName,
                            categoryImage: categoryImage,
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.authorName,
    required this.categoryName,
    required this.categoryImage,
  });

  final Map<String, dynamic> recipe;
  final dynamic authorName;
  final dynamic categoryName;
  final dynamic categoryImage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          print('WORKS!');
        },
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.asset(
                'assets/images/categories/' + categoryImage + '.webp',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['nombre'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.account,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          authorName,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.food,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          categoryName,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
