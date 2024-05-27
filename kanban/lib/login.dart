import 'package:flutter/material.dart';
import 'package:kanban/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<LoginPage> {
  final validatedata = GlobalKey<FormState>();
  TextEditingController user = TextEditingController();
  TextEditingController passw = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkApiKeyAndNavigate();
  }

  void checkApiKeyAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('api_key');

    if (apiKey != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'KANBAN')),
      );
    }
  }

  void login(String email, String password, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    // Genera una clave API aleatoria
    var random = Random.secure();
    var values = List<int>.generate(32, (i) => random.nextInt(256));
    var apiKey = base64UrlEncode(values);

    // Print the generated API key
    print('Generated API Key: $apiKey');

    // Guarda la clave API en SharedPreferences
    await prefs.setString('api_key', apiKey);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Credenciales y API Key guardadas con éxito!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const MyHomePage(
                title: 'KANBAN',
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
      ),
      body: Form(
        key: validatedata,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: user,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu correo electrónico';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passw,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu contraseña';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (validatedata.currentState!.validate()) {
                  login(user.text, passw.text, context);
                }
              },
              child: Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
