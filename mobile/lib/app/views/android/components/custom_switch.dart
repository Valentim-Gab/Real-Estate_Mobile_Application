import 'package:flutter/material.dart';
import 'package:mobile/app/controllers/app_controller.dart';
import 'package:provider/provider.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Switch(
        value: Provider.of<AppController>(context).isDarkTheme,
        onChanged: (_) {
          Provider.of<AppController>(context, listen: false).changeTheme();
        });
  }
}
