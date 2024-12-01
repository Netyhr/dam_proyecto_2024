import 'package:dam_proyecto_2024/pages/home_page.dart';
import 'package:dam_proyecto_2024/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade600,
              Colors.green.shade300,
              Colors.yellow.shade200
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40.0),
                child: Text(
                  '¡Bienvenido a Reshi!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                      color: Colors.brown.shade900,
                      shadows: [
                        Shadow(
                            offset: Offset(-2.0, 2.0),
                            blurRadius: 10.0,
                            color: const Color.fromARGB(85, 35, 31, 36)),
                      ]),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40.0),
                width: 300,
                child: Image.asset(
                  'assets/images/logo.webp',
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 40.0, bottom: 40.0),
                  child: SignUpWithGoogleButtonWidget())
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpWithGoogleButtonWidget extends StatelessWidget {
  const SignUpWithGoogleButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        User? user = await signInWithGoogle();
        if (user != null) {
          await addUserToDatabase(user);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      },
      icon: Icon(
        MdiIcons.google,
        size: 24,
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      label: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(
          'Iniciar sesión con Google',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
