import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/app/constants/app_colors.dart';

class Toasts {
  FToast fToast;

  Toasts() : fToast = FToast() {
    fToast = FToast();
  }

  showSuccess(String msg, context) {
    _showPrimaryToast(
      msg,
      context,
      Theme.of(context).colorScheme.onSurface,
      Icons.check,
      AppColors.successLight,
      AppColors.successDark,
    );
  }

  showError(String msg, context) {
    _showPrimaryToast(
      msg,
      context,
      Colors.white,
      Icons.error,
      AppColors.errorLight,
      AppColors.errorDark,
    );
  }

  _showPrimaryToast(
      String msg, context, textColor, icon, colorLight, colorDark) {
    fToast.init(context);
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDarkMode = brightness == Brightness.dark;

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: isDarkMode ? colorDark : colorLight),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            msg,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 1),
    );
  }
}
