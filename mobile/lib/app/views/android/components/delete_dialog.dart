import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/app/constants/app_colors.dart';

Future openDeleteDialog(VoidCallback onDeleteConfirmed, String text, context) {
  return showDialog(
    context: context,
    builder: (context) {
      final Brightness brightness = Theme.of(context).brightness;
      final bool isDarkMode = brightness == Brightness.dark;

      return Dialog(
        backgroundColor:
            isDarkMode ? AppColors.warningDark : AppColors.warningLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: dialogContent(context, text, onDeleteConfirmed),
      );
    },
  );
}

Widget dialogContent(
    BuildContext context, String text, VoidCallback onDeleteConfirmed) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: const <Widget>[
              Icon(
                Icons.warning,
                size: 48.0,
              ),
              SizedBox(height: 16.0),
              Text(
                'Confirma a exclusão?',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDeleteConfirmed();
                    },
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
