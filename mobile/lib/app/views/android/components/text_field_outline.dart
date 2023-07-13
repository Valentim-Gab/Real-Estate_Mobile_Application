import 'package:flutter/material.dart';
import 'package:mobile/app/constants/app_colors.dart';

Widget customTextFieldOutline(
    TextInputType textInputType,
    String text,
    bool obscureText,
    TextEditingController controller,
    Color outlineColor,
    bool required) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (required && value!.isEmpty) {
        return 'Campo obrigatório';
      }
      return null;
    },
    keyboardType: textInputType,
    style: TextStyle(color: outlineColor),
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: outlineColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: outlineColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Widget customTextFieldOutlinePassword(
    TextInputType textInputType,
    String text,
    bool obscureText,
    TextEditingController controller1,
    TextEditingController controller2,
    Color outlineColor,
    bool required) {
  return TextFormField(
    controller: controller1,
    validator: (value) {
      if (required && value!.isEmpty) {
        return 'Campo obrigatório';
      } else if (value != controller2.text) {
        return 'As senhas não coincidem';
      }
      return null;
    },
    keyboardType: textInputType,
    style: TextStyle(color: outlineColor),
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: outlineColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: outlineColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Widget customTextFieldOutlineRegex(
    TextInputType textInputType,
    String text,
    bool obscureText,
    controller,
    Color outlineColor,
    bool required,
    String pattern) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (required && value!.isEmpty) {
        return 'Campo obrigatório';
      } else if (!validateByRegex(value!, pattern)) {
        return 'Email inválido';
      }
      return null;
    },
    keyboardType: textInputType,
    style: TextStyle(color: outlineColor),
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: outlineColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: outlineColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

bool validateByRegex(String value, String pattern) {
  final regex = RegExp(pattern);
  return regex.hasMatch(value);
}
