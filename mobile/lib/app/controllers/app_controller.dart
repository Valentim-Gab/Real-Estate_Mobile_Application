import 'package:flutter/material.dart';
import 'package:mobile/app/database/config_dao.dart';
import 'package:mobile/app/views/android/screens/login_screen.dart';
import 'package:mobile/app/views/android/screens/profile_screen.dart';
import 'package:mobile/app/views/android/screens/property_edit_screen.dart';
import 'package:mobile/app/views/android/screens/property_register_screen.dart';
import 'package:mobile/app/views/android/screens/property_screen.dart';
import 'package:mobile/app/views/android/screens/home_page.dart';
import 'package:mobile/app/views/android/screens/register_screen.dart';

class AppController extends ChangeNotifier {
  final ConfigDao _configDao = ConfigDao();

  bool isDarkTheme = false;

  Future<bool> getDarkTheme() async {
    isDarkTheme = await _configDao.getDarkMode();

    return isDarkTheme;
  }

  void changeTheme() {
    isDarkTheme = !isDarkTheme;

    notifyListeners();
    _configDao.create(isDarkTheme);
  }

  appRouters() {
    return {
      '/': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/home': (context) => const HomeScreen(),
      '/property': (context) => PropertyScreen(
            propertyId: ModalRoute.of(context)!.settings.arguments as int,
          ),
      '/profile': (context) => const ProfileScreen(),
      '/property/new': (context) => const PropertyRegisterScreen(),
      '/property/edit': (context) => PropertyEditScreen(
            propertyId: ModalRoute.of(context)!.settings.arguments as int,
          )
    };
  }
}
