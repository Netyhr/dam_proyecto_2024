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
          decoration: BoxDecoration(color: Colors.green.shade50),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.green.shade50,
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () async => {
                    await signOut(),
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    )
                  },
                  icon: Icon(MdiIcons.exitToApp),
                  label: Text('Cerrar sesión'),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.green.shade50,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: pages[currentPageIndex],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(MdiIcons.plus),
        backgroundColor: Colors.redAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green.shade50,
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
