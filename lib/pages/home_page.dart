import 'package:dam_proyecto_2024/pages/add_recipe_page.dart';
import 'package:dam_proyecto_2024/pages/categories_page.dart';
import 'package:dam_proyecto_2024/pages/login_page.dart';
import 'package:dam_proyecto_2024/pages/recipes_page.dart';
import 'package:dam_proyecto_2024/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  final List<String> appBarTitles = [
    'Recetas',
    'Categorías',
  ];

  final List<Widget> pages = [
    RecipesPage(),
    CategoriesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[currentPageIndex]),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.green.shade200),
        ),
        actions: [
          IconButton(
              icon: Icon(MdiIcons.exitToApp),
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('¿Cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () async => {
                            await signOut(),
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false)
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => LoginPage()),
                            // )
                          },
                          child: Text('Si'),
                        ),
                      ],
                    );
                  },
                );
              }),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.green.shade200,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: pages[currentPageIndex],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRecipePage(),
              ));
        },
        shape: CircleBorder(),
        child: Icon(MdiIcons.plus),
        backgroundColor: Colors.redAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green.shade200,
        fixedColor: Colors.brown.shade800,
        iconSize: 24,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.silverware),
            label: 'Recetas',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.food),
            label: 'Categorias',
          ),
        ],
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}
