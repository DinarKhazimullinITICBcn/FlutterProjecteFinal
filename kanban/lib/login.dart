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
    _checkApiKey(); // Comprova si l'API key ja existeix
  }

  // Funció per comprovar si l'API key ja està guardada a SharedPreferences
  void _checkApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    var apiKey = prefs.getString('api_key');
    if (apiKey != null) {
      // Si l'API key existeix, navega directament a la pàgina principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'KANBAN')),
      );
    }
  }

  // Funció per iniciar sessió i guardar les credencials i l'API key
  void login(String email, String password, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email); // Guarda el correu electrònic
    await prefs.setString('password', password); // Guarda la contrasenya

    var apiKey = prefs.getString('api_key');
    if (apiKey == null) {
      // Si l'API key no existeix, genera una de nova
      var random = Random.secure();
      var values = List<int>.generate(32, (i) => random.nextInt(256));
      apiKey = base64UrlEncode(values);

      try {
        await prefs.setString('api_key', apiKey); // Guarda l'API key generada
      } catch (e) {
        print('Error guardant l\'API key: $e');
        return;
      }
    }

    // Mostra un missatge de confirmació
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Credencials i API Key guardades amb èxit!')),
    );

    // Navega a la pàgina principal
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'KANBAN')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sessió'),
      ),
      body: Form(
        key: validatedata,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: user,
                decoration: const InputDecoration(
                  labelText: 'Correu electrònic',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Si us plau, introdueix el teu correu electrònic';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passw,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contrasenya',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Si us plau, introdueix la teva contrasenya';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (validatedata.currentState!.validate()) {
                  login(user.text, passw.text, context); // Crida a la funció d'inici de sessió
                }
              },
              child: const Text('Iniciar sessió'),
            ),
          ],
        ),
      ),
    );
  }
}
