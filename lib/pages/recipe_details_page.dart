import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RecipeDetailsPage extends StatelessWidget {
  const RecipeDetailsPage(
      {super.key,
      required this.recipe,
      required this.authorName,
      required this.categoryImage,
      required this.categoryName});

  final Map<String, dynamic> recipe;
  final String? authorName;
  final String? categoryImage;
  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe['nombre'],
          style: TextStyle(color: Colors.brown.shade800),
        ),
        iconTheme: IconThemeData(color: Colors.brown.shade800),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/categories/${categoryImage}.webp',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['nombre'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          MdiIcons.account,
                          color: Colors.brown.shade600,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            authorName ?? 'Usuario desconocido',
                            style: TextStyle(color: Colors.brown.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          MdiIcons.food,
                          color: Colors.brown.shade600,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            categoryName ?? 'Categoría desconocida',
                            style: TextStyle(color: Colors.brown.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Instrucciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      recipe['instrucciones'] ??
                          'No hay instrucciones disponibles.',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
