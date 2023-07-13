import 'package:flutter/material.dart';
import 'package:mobile/app/models/property.dart';
import 'package:mobile/app/services/property_service.dart';
import 'package:mobile/app/views/android/components/form_property.dart';

class PropertyEditScreen extends StatefulWidget {
  final int propertyId;

  const PropertyEditScreen({Key? key, required this.propertyId})
      : super(key: key);

  @override
  State<PropertyEditScreen> createState() => _PropertyEditScreenState();
}

class _PropertyEditScreenState extends State<PropertyEditScreen> {
  final PropertyService _propertyService = PropertyService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar propriedade'),
      ),
      body: FutureBuilder(
          initialData: null,
          future: _propertyService.getProperty(widget.propertyId, context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final Property? property = snapshot.data;

            return FormProperty(property: property);
          }),
    );
  }
}
