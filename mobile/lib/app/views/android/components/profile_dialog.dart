import 'package:flutter/material.dart';
import 'package:mobile/app/models/user.dart';
import 'package:mobile/app/services/user_service.dart';
import 'package:mobile/app/constants/app_colors.dart';
import 'package:mobile/app/views/android/components/text_field_outline.dart';

final _formKey = GlobalKey<FormState>();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _password2Controller = TextEditingController();
UserService userService = UserService();

Future openProfileDialog(context, User user) async => await showDialog(
    context: context,
    builder: (context) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _passwordController.text = '';
      _password2Controller.text = '';
      return Form(
        key: _formKey,
        child: SimpleDialog(
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Editar dados'),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
          children: [
            customTextFieldOutline(
              TextInputType.name,
              'Name',
              false,
              _nameController,
              Theme.of(context).colorScheme.onSurface,
              true,
            ),
            const SizedBox(height: 20),
            customTextFieldOutlineRegex(
              TextInputType.emailAddress,
              'Email',
              false,
              _emailController,
              Theme.of(context).colorScheme.onSurface,
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
              Theme.of(context).colorScheme.onSurface,
              true,
            ),
            const SizedBox(height: 20),
            customTextFieldOutlinePassword(
              TextInputType.visiblePassword,
              'Redigite a senha',
              true,
              _password2Controller,
              _passwordController,
              Theme.of(context).colorScheme.onSurface,
              true,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: AppColors.errorColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      UserService().update(
                        User(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                        context,
                      );
                    }
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            )
          ],
        ),
      );
    });
