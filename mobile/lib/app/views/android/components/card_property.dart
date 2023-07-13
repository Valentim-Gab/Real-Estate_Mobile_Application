import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/app/models/property.dart';
import 'package:mobile/app/constants/app_colors.dart';
import 'package:mobile/app/services/property_service.dart';
import 'package:outlined_text/outlined_text.dart';

class CardProperty extends StatefulWidget {
  final Property property;

  const CardProperty({Key? key, required this.property}) : super(key: key);

  @override
  State<CardProperty> createState() => _CardPropertyState();
}

class _CardPropertyState extends State<CardProperty> {
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  PropertyService propertyService = PropertyService();

  String _formatCurrencyValue(double value) {
    return _currencyFormat.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Column(
        children: [
          widgetImgCard(),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widgetHeaderCard(),
                const Divider(),
                Text(
                  widget.property.identifierName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text(
                  widget.property.getAddress() ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  widget.property.getAddressCity() ?? 'Cidade não informada',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.property.description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
                Row(
                  children: [
                    widgetValue(),
                    widgetButton(context),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetImgCard() {
    return Center(
      child: FutureBuilder(
          future: widget.property.img != null
              ? propertyService.getMainImg(
                  widget.property.img!,
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
              final image = Image.memory(
                Uint8List.fromList(imageBytes),
                fit: BoxFit.cover,
              );

              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: image,
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  Widget widgetHeaderCard() {
    return Row(
      children: [
        Text(
          widget.property.typeMarketing,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Icon(
          getIconTypeProperty(),
          size: 30,
        )
      ],
    );
  }

  IconData getIconTypeProperty() {
    if (widget.property.identifierName.toLowerCase() == 'casa') {
      return Icons.house;
    } else if (widget.property.identifierName.toLowerCase() == 'apartamento') {
      return Icons.apartment;
    }
    return Icons.real_estate_agent;
  }

  Widget widgetValue() {
    return Expanded(
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: OutlinedText(
          text: Text(
            _formatCurrencyValue(widget.property.value ?? 0),
            style: TextStyle(
              fontSize: 20,
              color: AppColors.moneyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          strokes: [
            OutlinedTextStroke(color: Colors.black, width: 4),
          ],
        ),
      ),
    );
  }

  Widget widgetButton(context) {
    return Expanded(
      child: ButtonTheme(
        child: ButtonBar(
          children: [
            TextButton(
              child: const Text('VISUALIZAR',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/property', arguments: widget.property.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
