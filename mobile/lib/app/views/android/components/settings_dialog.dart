import 'package:flutter/material.dart';
import 'package:mobile/app/views/android/components/custom_switch.dart';

Future openSettingsDialog(context) => showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Configurações'),
        children: [
          Row(
            children: const [CustomSwitch(), Text('Modo escuro')],
          )
        ],
      ),
    );
