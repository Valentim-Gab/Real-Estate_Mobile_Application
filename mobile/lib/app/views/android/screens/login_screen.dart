import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/app/database/login_dao.dart';
import 'package:mobile/app/models/login.dart';
import 'package:mobile/app/services/login_service.dart';
import 'package:mobile/app/constants/app_colors.dart';
import 'package:mobile/app/views/android/components/text_field_outline.dart';
import 'package:outlined_text/outlined_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginService loginService = LoginService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/login_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          Center(
            child: _body(),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                width: 250,
                child: Image.asset('assets/images/main_logo.png'),
              ),
            ),
            Card(
                color: Colors.black.withOpacity(0.75),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: formLogin()),
            TextButton(
              child: OutlinedText(
                text: const Text(
                  'Cadastrar-se',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                strokes: [
                  OutlinedTextStroke(color: Colors.black, width: 4),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/register');
              },
            )
          ],
        ),
      ),
    );
  }

  Widget formLogin() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
        child: Column(
          children: [
            customTextFieldOutline(TextInputType.emailAddress, 'Email', false,
                _emailController, Colors.white, true),
            const SizedBox(
              height: 20,
            ),
            customTextFieldOutline(TextInputType.visiblePassword, 'Senha', true,
                _passwordController, Colors.white, true),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  const Size(double.infinity, 50),
                ),
                backgroundColor:
                    MaterialStateProperty.all(AppColors.secondaryColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  login();
                }
              },
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    await loginService
        .login(
      Login(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    )
        .then((Response response) async {
      final jsonData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final logged = await LoginDao().login(Login.fromJsonToken(jsonData));

        if (logged) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Logado'),
            backgroundColor: AppColors.successDark,
          ));
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            jsonData['message'],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.errorDark,
        ));
      }
    });
  }
}
