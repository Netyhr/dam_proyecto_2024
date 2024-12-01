import 'package:dam_proyecto_2024/services/category_service.dart';
import 'package:dam_proyecto_2024/services/recipe_service.dart';
import 'package:dam_proyecto_2024/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CategoriesRecipesPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoriesRecipesPage(
      {super.key, required this.categoryName, required this.categoryId});

  @override
  State<CategoriesRecipesPage> createState() => _CategoriesRecipesPageState();
}

class _CategoriesRecipesPageState extends State<CategoriesRecipesPage> {
  bool _showOnlyMyRecipes = false;
  final RecipeService _recipeService = RecipeService();
  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas de ${widget.categoryName}'),
        backgroundColor: Colors.green.shade200,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.yellow.shade50,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Mis recetas',
                      style: TextStyle(
                        color: Colors.brown.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Switch(
                    value: _showOnlyMyRecipes,
                    onChanged: (value) {
                      setState(() {
                        _showOnlyMyRecipes = value;
                      });
                    },
                    activeColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: _showOnlyMyRecipes
                      ? _recipeService
                          .getUserRecipesByCategory(widget.categoryId)
                      : _recipeService
                          .getAllRecipesByCategory(widget.categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error al cargar las recetas'),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe =
                            recipes[index].data() as Map<String, dynamic>;
                        final recipeId = recipes[index].id;

                        return FutureBuilder(
                          future: _recipeService.getUserById(recipe['autor']),
                          builder: (context, authorSnapshot) {
                            final authorName =
                                authorSnapshot.data?.get('nombre') ??
                                    'Usuario desconocido';
                            return FutureBuilder(
                              future: _categoryService
                                  .getCategoryById(recipe['categoria']),
                              builder: (context, categorySnapshot) {
                                final categoryImage =
                                    categorySnapshot.data?.get('foto') ??
                                        'none';
                                final categoryName =
                                    categorySnapshot.data?.get('nombre') ??
                                        'Categoría desconocida';

                                return FutureBuilder(
                                  future: _recipeService.checkAuthor(recipeId),
                                  builder: (context, isAuthorSnapshot) {
                                    final isAuthor = isAuthorSnapshot.data;

                                    if (!isAuthorSnapshot.hasData ||
                                        isAuthorSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 90.0),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    }
                                    if (isAuthor == false) {
                                      return RecipeCard(
                                        recipe: recipe,
                                        recipeId: recipeId,
                                        authorName: authorName,
                                        categoryName: categoryName,
                                        categoryImage: categoryImage,
                                      );
                                    } else {
                                      return Slidable(
                                        key: ValueKey(recipeId),
                                        endActionPane: ActionPane(
                                          motion: ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) async {
                                                return showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return DeleteAlertDialog(
                                                        context, recipeId);
                                                  },
                                                );
                                              },
                                              icon: MdiIcons.trashCan,
                                              label: 'Eliminar',
                                              backgroundColor:
                                                  Colors.yellow.shade50,
                                            )
                                          ],
                                        ),
                                        child: RecipeCard(
                                            recipe: recipe,
                                            recipeId: recipeId,
                                            authorName: authorName,
                                            categoryName: categoryName,
                                            categoryImage: categoryImage),
                                      );
                                    }
                                  },
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
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog DeleteAlertDialog(BuildContext context, String recipeId) {
    return AlertDialog(
      title: Text('Eliminar receta'),
      content: Text('¿Estás seguro de que quieres eliminar esta receta?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar')),
        TextButton(
          onPressed: () async {
            bool? confirmDelete = await RecipeService().deleteRecipe(recipeId);

            if (confirmDelete) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Receta eliminada con éxito.'),
                backgroundColor: Colors.green,
              ));
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('No puedes eliminar una receta que no te pertenece.'),
                backgroundColor: Colors.redAccent,
              ));
              Navigator.pop(context);
            }
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}
