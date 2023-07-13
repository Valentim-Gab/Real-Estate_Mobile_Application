import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/app/models/property.dart';
import 'package:mobile/app/services/property_service.dart';
import 'package:mobile/app/constants/app_colors.dart';
import 'package:mobile/app/views/android/components/custom_field.dart';
import 'package:mobile/app/views/android/components/delete_dialog.dart';

class PropertyScreen extends StatefulWidget {
  final int propertyId;

  const PropertyScreen({Key? key, required this.propertyId}) : super(key: key);

  @override
  State<PropertyScreen> createState() => PropertyScreenState();
}

class PropertyScreenState extends State<PropertyScreen> {
  final PropertyService _propertyService = PropertyService();
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  String _formatCurrencyValue(double value) {
    return _currencyFormat.format(value);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar imóvel'),
        actions: [
          IconButton(
            onPressed: () {
              openDeleteDialog(() {
                _propertyService.delete(widget.propertyId, context);
              }, 'Seu imóvel será deletado permanentemente!', context);
            },
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Future.delayed(const Duration(seconds: 0));
          setState(() {});
        },
        child: FutureBuilder(
            initialData: null,
            future: _propertyService.getProperty(widget.propertyId, context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasData) {
                final Property? property = snapshot.data;

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        '${property?.typeMarketing ?? 'Não informado'} - ${property?.identifierName ?? 'Dados a seguir'}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Divider(),
                    customField(
                      'Valor: ',
                      _formatCurrencyValue(property?.value ?? 0),
                    ),
                    const Divider(),
                    customField(
                        'Número: ', property?.numberProperty.toString() ?? ''),
                    const Divider(),
                    customField('Rua: ', property?.road ?? ''),
                    const Divider(),
                    customField('Bairro: ', property?.neighborhood ?? ''),
                    const Divider(),
                    customField('Cidade: ', property?.city ?? ''),
                    const Divider(),
                    customField('Estado: ', property?.state ?? ''),
                    const Divider(),
                    customField('País: ', property?.country ?? ''),
                    const Divider(),
                    customField('CEP: ', property?.zipCode ?? ''),
                    const Divider(),
                    customField('Tipo de uso: ', property?.typeUse ?? ''),
                    const Divider(),
                    customField('Proprietário: ', property?.ownerName ?? ''),
                    const Divider(height: 30),
                    Column(
                      children: [
                        const Text(
                          'Descrição: ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.secondaryColor,
                          ),
                          child: Text(
                            property?.description ?? 'Não há descrição',
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    widgetImgCard(property)
                  ],
                );
              }

              return const Center(
                child: Text('Ocorreu um erro'),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/property/edit', arguments: widget.propertyId);
        },
      ),
    );
  }

  Widget widgetImgCard(Property? property) {
    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Imagem do imóvel:',
              style: TextStyle(fontSize: 16),
            ),
          ),
          FutureBuilder(
              future: property != null && property.img != null
                  ? _propertyService.getMainImg(
                      property.img!,
                      context,
                    )
                  : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasData) {
                  final imageBytes = snapshot.data!;
                  final image = Image.memory(Uint8List.fromList(imageBytes));

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: image,
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ],
      ),
    );
  }
}
