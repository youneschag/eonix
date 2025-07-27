import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorText;

  bool _isEmailValid(String email) {
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(email);
  }

  bool _isPasswordSecure(String password) {
    // 8 caractères, 1 majuscule, 1 minuscule, 1 caractère spécial
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#\$&*~._\-]).{8,}$');
    return regex.hasMatch(password);
  }

  void _login(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => errorText = "Tous les champs sont obligatoires");
      return;
    }
    if (!_isEmailValid(email)) {
      setState(() => errorText = "Email invalide");
      return;
    }
    if (!_isPasswordSecure(password)) {
      setState(() => errorText = "Mot de passe trop faible (8 caractères, 1 majuscule, 1 minuscule, 1 caractère spécial)");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("userName", username);

    Navigator.pushReplacementNamed(context, '/home', arguments: username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Row(
            children: [
              // Colonne gauche : formulaire
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bienvenue dans Eonix", style: TextStyle(fontSize: 24)),
                      SizedBox(height: 24),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(labelText: "Nom d'utilisateur"),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: "Mot de passe"),
                        obscureText: true,
                      ),
                      if (errorText != null) ...[
                        SizedBox(height: 12),
                        Text(errorText!, style: TextStyle(color: Colors.red)),
                      ],
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _login(context),
                        child: Text("Se connecter"),
                      ),
                    ],
                  ),
                ),
              ),
              // Colonne droite : autres moyens de connexion
              Container(
                width: 1,
                color: Colors.grey[300],
                margin: EdgeInsets.symmetric(vertical: 40),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Ou connectez-vous avec", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Ajouter la logique Google
                        },
                        icon: Icon(Icons.g_mobiledata, color: Colors.red),
                        label: Text("Google"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 48),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Ajouter la logique Apple
                        },
                        icon: Icon(Icons.apple, color: Colors.black),
                        label: Text("Apple"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
