import 'package:flutter/material.dart';
import 'package:mobile/app/models/user.dart';
import 'package:mobile/app/services/user_service.dart';
import 'package:mobile/app/constants/app_colors.dart';
import 'package:mobile/app/views/android/components/text_field_outline.dart';
import 'package:outlined_text/outlined_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  UserService userService = UserService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
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
              child: formRegister(),
            ),
            TextButton(
              child: OutlinedText(
                text: const Text(
                  'Fazer Login',
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
                Navigator.of(context).pushReplacementNamed('/');
              },
            )
          ],
        ),
      ),
    );
  }

  Widget formRegister() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
        child: Column(children: [
          customTextFieldOutline(
            TextInputType.name,
            'Name',
            false,
            _nameController,
            Colors.white,
            true,
          ),
          const SizedBox(height: 20),
          customTextFieldOutlineRegex(
            TextInputType.emailAddress,
            'Email',
            false,
            _emailController,
            Colors.white,
            true,
            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
          ),
          const SizedBox(height: 20),
          customTextFieldOutlinePassword(
            TextInputType.visiblePassword,
            'Senha',
            true,
            _passwordController,
            _password2Controller,
            Colors.white,
            true,
          ),
          const SizedBox(height: 20),
          customTextFieldOutlinePassword(
            TextInputType.visiblePassword,
            'Redigite a senha',
            true,
            _password2Controller,
            _passwordController,
            Colors.white,
            true,
          ),
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
                  UserService().save(
                    User(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                    context,
                  );
                }
              },
              child: const Text('Casastrar')),
        ]),
      ),
    );
  }
}
