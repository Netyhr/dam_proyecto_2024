import 'package:dam_proyecto_2024/pages/recipe_details_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.recipeId,
    required this.authorName,
    required this.categoryName,
    required this.categoryImage,
  });

  final Map<String, dynamic> recipe;
  final dynamic recipeId;
  final dynamic authorName;
  final dynamic categoryName;
  final dynamic categoryImage;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                builder: (context) => RecipeDetailsPage(
                  recipe: recipe,
                  authorName: authorName,
                  categoryName: categoryName,
                  categoryImage: categoryImage,
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
                'assets/images/categories/' + categoryImage + '.webp',
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
                    recipe['nombre'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Icon(
                          MdiIcons.account,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Text(
                            authorName,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.food,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.0),
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
