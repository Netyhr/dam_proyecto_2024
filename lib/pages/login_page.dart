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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: SignUpWithGoogleButtonWidget())
          ],
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
        size: 36,
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(300, 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      label: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'Iniciar sesión con Google',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
