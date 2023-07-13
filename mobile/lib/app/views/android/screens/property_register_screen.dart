import 'package:flutter/material.dart';
import 'package:mobile/app/views/android/components/form_property.dart';

class PropertyRegisterScreen extends StatelessWidget {
  const PropertyRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar propriedade'),
      ),
      body: const FormProperty(),
    );
  }
}
