import 'package:dam_proyecto_2024/pages/categories_recipes_page.dart';
import 'package:flutter/material.dart';

import '../services/category_service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Expanded(
            child: StreamBuilder(
          stream: _categoryService.getAllCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al cargar las categorias',
                  style: TextStyle(color: Colors.brown.shade800),
                ),
              );
            }

            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final categories = snapshot.data?.docs ?? [];

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category =
                    categories[index].data() as Map<String, dynamic>;
                final categoryId = categories[index].id;

                return Padding(
                  padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriesRecipesPage(
                                categoryId: categoryId,
                                categoryName: category['nombre'],
                              ),
                            ));
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/images/categories/${category['foto']}.webp',
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category['nombre'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown.shade800),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ))
      ],
    );
  }
}
