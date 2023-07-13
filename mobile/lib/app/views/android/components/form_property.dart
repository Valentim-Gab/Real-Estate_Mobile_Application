import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile/app/models/property.dart';
import 'package:mobile/app/services/property_service.dart';
import 'package:mobile/app/services/user_service.dart';
import 'package:mobile/app/constants/app_colors.dart';
import 'package:mobile/app/views/android/components/toasts.dart';

final cepMaskFormatter = MaskTextInputFormatter(mask: '#####-###');

class FormProperty extends StatefulWidget {
  final Property? property;

  const FormProperty({Key? key, this.property}) : super(key: key);

  @override
  State<FormProperty> createState() => _FormPropertyState();
}

class _FormPropertyState extends State<FormProperty> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _textEditingControllerMap = {
    'identifierName': TextEditingController(),
    'value': TextEditingController(),
    'ownerName': TextEditingController(),
    'numberProperty': TextEditingController(),
    'road': TextEditingController(),
    'neighborhood': TextEditingController(),
    'city': TextEditingController(),
    'state': TextEditingController(),
    'country': TextEditingController(),
    'zipCode': TextEditingController(),
    'description': TextEditingController(),
    'typeUse': TextEditingController(),
    'typeMarketing': TextEditingController(),
  };
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  File? selectedImage;
  final PropertyService propertyService = PropertyService();
  MultipartFile? multipartFile;

  @override
  void dispose() {
    for (final controller in _textEditingControllerMap.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      _textEditingControllerMap['identifierName']!.text =
          widget.property?.identifierName ?? '';
      _textEditingControllerMap['value']!.text =
          _formatCurrencyValue(widget.property?.value ?? 0);
      _textEditingControllerMap['ownerName']!.text =
          widget.property?.ownerName ?? '';
      _textEditingControllerMap['numberProperty']!.text =
          widget.property?.numberProperty.toString() ?? '';
      _textEditingControllerMap['road']!.text = widget.property?.road ?? '';
      _textEditingControllerMap['neighborhood']!.text =
          widget.property?.neighborhood ?? '';
      _textEditingControllerMap['city']!.text = widget.property?.city ?? '';
      _textEditingControllerMap['state']!.text = widget.property?.state ?? '';
      _textEditingControllerMap['country']!.text =
          widget.property?.country ?? '';
      _textEditingControllerMap['zipCode']!.text =
          widget.property?.zipCode ?? '';
      _textEditingControllerMap['description']!.text =
          widget.property?.description ?? '';
      _textEditingControllerMap['typeUse']!.text =
          widget.property?.typeUse ?? '';
      _textEditingControllerMap['typeMarketing']!.text =
          widget.property?.typeMarketing ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> itemsTypeProperty = [
      {
        'value': 'casa',
        'text': 'Casa',
        'icon': Icons.house_rounded,
      },
      {
        'value': 'apartamento',
        'text': 'Apartamento',
        'icon': Icons.apartment_rounded,
      }
    ];

    final List<dynamic> itemsTypeUse = [
      {
        'value': 'residencial',
        'text': 'Residencial',
        'icon': Icons.home,
      },
      {
        'value': 'comercial',
        'text': 'Comercial',
        'icon': Icons.local_convenience_store_rounded,
      }
    ];

    final List<dynamic> itemsTypeTypeMarketing = [
      {
        'value': 'aluguel',
        'text': 'Aluguel',
        'icon': Icons.home_work,
      },
      {
        'value': 'venda',
        'text': 'Venda',
        'icon': Icons.monetization_on,
      }
    ];

    Future<void> selectImageFromGallery() async {
      final imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final file = File(pickedImage.path);
        final filename = file.path.split('/').last;

        multipartFile = await MultipartFile.fromPath(
          'image',
          file.path,
          filename: filename,
        );

        setState(() {
          selectedImage = file;
        });
      }
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: ListView(
          children: [
            dropDownCustom(
              itemsTypeProperty,
              _textEditingControllerMap['identifierName']!,
              'Tipo de imóvel',
            ),
            textFormFieldCustom(
              _textEditingControllerMap['ownerName']!,
              'Nome do proprietário',
              false,
            ),
            numberFormFieldCustom(
              _textEditingControllerMap['value']!,
              'Valor',
              false,
              'R\$',
              true,
            ),
            numberFormFieldCustom(
              _textEditingControllerMap['numberProperty']!,
              'Número da propriedade',
              true,
              '',
              false,
            ),
            TextFormZipCode(
              textEditingControllerMap: _textEditingControllerMap,
              required: false,
            ),
            textFormFieldCustom(
              _textEditingControllerMap['road']!,
              'Rua',
              false,
            ),
            textFormFieldCustom(
              _textEditingControllerMap['neighborhood']!,
              'Bairro',
              false,
            ),
            textFormFieldCustom(
              _textEditingControllerMap['city']!,
              'Cidade',
              false,
            ),
            textFormFieldCustom(
              _textEditingControllerMap['state']!,
              'Estado',
              false,
            ),
            textFormFieldCustom(
              _textEditingControllerMap['country']!,
              'País',
              false,
            ),
            dropDownCustom(
              itemsTypeUse,
              _textEditingControllerMap['typeUse']!,
              'Tipo de uso',
            ),
            dropDownCustom(
              itemsTypeTypeMarketing,
              _textEditingControllerMap['typeMarketing']!,
              'Tipo de contrato',
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _textEditingControllerMap['description']!,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Imagem do imóvel: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      FutureBuilder(
                          future: widget.property != null &&
                                  widget.property!.img != null
                              ? propertyService.getMainImg(
                                  widget.property!.img!,
                                  context,
                                )
                              : null,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: CircularProgressIndicator()),
                              );
                            } else if (selectedImage != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(selectedImage!),
                              );
                            } else if (snapshot.hasData) {
                              final imageBytes = snapshot.data!;

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                    Uint8List.fromList(imageBytes)),
                              );
                            } else {
                              return const SizedBox(
                                height: 80,
                              );
                            }
                          }),
                      InkWell(
                        onTap: selectImageFromGallery,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondaryColor),
                          padding: const EdgeInsets.all(16),
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                child: const Text('Enviar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final double value =
                        _textEditingControllerMap['value']!.text.isEmpty
                            ? 0
                            : _parseCurrencyValue(
                                _textEditingControllerMap['value']!.text);

                    final int? numberProperty = _textEditingControllerMap[
                                'numberProperty']!
                            .text
                            .isNotEmpty
                        ? int.parse(
                            _textEditingControllerMap['numberProperty']!.text)
                        : null;

                    Property newProperty = Property(
                      identifierName:
                          _textEditingControllerMap['identifierName']!.text,
                      value: value,
                      ownerName: _textEditingControllerMap['ownerName']!.text,
                      numberProperty: numberProperty,
                      road: _textEditingControllerMap['road']!.text,
                      neighborhood:
                          _textEditingControllerMap['neighborhood']!.text,
                      city: _textEditingControllerMap['city']!.text,
                      state: _textEditingControllerMap['state']!.text,
                      country: _textEditingControllerMap['country']!.text,
                      zipCode: _textEditingControllerMap['zipCode']!.text,
                      description:
                          _textEditingControllerMap['description']!.text,
                      typeUse: _textEditingControllerMap['typeUse']!.text,
                      typeMarketing:
                          _textEditingControllerMap['typeMarketing']!.text,
                      user: await UserService().getUserLogged(context),
                    );

                    _submitForm(newProperty);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dropDownCustom(List<dynamic> items, TextEditingController controller,
      String placeholder) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (var item in items) {
      dropdownItems.add(
        DropdownMenuItem<String>(
          value: item['value'] as String,
          child: Row(
            children: [
              Icon(item['icon'] as IconData),
              const SizedBox(width: 8),
              Text(item['text'] as String),
            ],
          ),
        ),
      );
    }

    return DropdownButtonFormField(
      value: controller.text != '' ? controller.text.toLowerCase() : null,
      hint: Text(placeholder),
      borderRadius: BorderRadius.circular(10),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16),
      ),
      items: dropdownItems,
      validator: (value) {
        if (value == null) {
          return 'Campo obrigatório';
        }
        return null;
      },
      onChanged: (item) {
        if (item != null) {
          controller.text = item;
        }
      },
    );
  }

  Widget textFormFieldCustom(
      TextEditingController controller, String label, bool required) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (required && value!.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget numberFormFieldCustom(TextEditingController controller, String label,
      bool required, String sulffixText, bool decimal) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      validator: (value) {
        if (required && value!.isEmpty) {
          return 'Campo obrigatório';
        }

        if (!decimal &&
            value!.isNotEmpty &&
            (value.contains(',') || value.contains('.'))) {
          return 'Apenas números inteiros';
        }
        return null;
      },
      decoration: InputDecoration(labelText: label, suffixText: sulffixText),
    );
  }

  void _submitForm(Property property) {
    if (multipartFile != null) {
      if (widget.property != null && widget.property!.id != -1) {
        propertyService.updateWithFile(
            property, widget.property!.id, context, multipartFile);
      } else {
        propertyService.save(property, context, multipartFile);
      }
    } else if (widget.property != null &&
        widget.property!.id != -1 &&
        widget.property!.img != null &&
        widget.property!.img != '') {
      propertyService.update(property, widget.property!.id, context);
    } else {
      Toasts().showError('Imagem obrigatória', context);
    }
  }

  String _formatCurrencyValue(double value) {
    return _currencyFormat.format(value);
  }

  double _parseCurrencyValue(String value) {
    return _currencyFormat.parse(value) as double;
  }
}

class TextFormZipCode extends StatefulWidget {
  final Map<String, TextEditingController> textEditingControllerMap;
  final bool required;

  const TextFormZipCode(
      {Key? key,
      required this.textEditingControllerMap,
      required this.required})
      : super(key: key);

  @override
  State<TextFormZipCode> createState() => _TextFormZipCodeState();
}

class _TextFormZipCodeState extends State<TextFormZipCode> {
  bool showError = false;
  PropertyService propertyService = PropertyService();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingControllerMap['zipCode'],
      keyboardType: TextInputType.number,
      validator: (value) {
        if (widget.required && (value == null || value.isEmpty)) {
          return 'Campo obrigatório';
        }
        if (value != null && value.isNotEmpty && value.length != 9) {
          return 'CEP inválido';
        }

        return null;
      },
      inputFormatters: [cepMaskFormatter],
      decoration: InputDecoration(
        labelText: 'CEP',
        hintText: '12345-678',
        errorText: showError ? 'CEP não encontrado' : null,
        errorStyle: TextStyle(color: AppColors.errorColor),
      ),
      onChanged: (value) async {
        if (value.length == 9) {
          final data =
              await propertyService.getAddressByZipCode(value, context);

          if (data['erro'] != true) {
            setState(() {
              showError = false;
            });
            widget.textEditingControllerMap['road']!.text = data['logradouro'];
            widget.textEditingControllerMap['neighborhood']!.text =
                data['bairro'];
            widget.textEditingControllerMap['city']!.text = data['localidade'];
            widget.textEditingControllerMap['state']!.text = data['uf'];
            widget.textEditingControllerMap['country']!.text = 'Brasil';
          } else {
            setState(() {
              showError = true;
            });
          }
        }
      },
    );
  }
}
