import 'package:flutter/material.dart';
import 'package:mobile/app/controllers/app_controller.dart';
import 'package:mobile/app/constants/app_colors.dart';
import 'package:mobile/app/services/user_service.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();

    return ChangeNotifierProvider(
      create: (_) => AppController(),
      child: Consumer<AppController>(builder: (context, appController, child) {
        return FutureBuilder(
            future: Future.any([
              userService.verifyLogin(),
              Future.delayed(const Duration(seconds: 10))
            ]),
            builder: (context, snapshot) {
              bool? isValidToken = snapshot.data;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: AppColors.secondaryColor,
                  child: const Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                  ),
                );
              } else if (snapshot.hasData && isValidToken != null) {
                return FutureBuilder(
                  future: appController.getDarkTheme(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        color: AppColors.secondaryColor,
                        child: const Center(
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              )),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      bool? isDarkTheme = snapshot.data;

                      return MaterialApp(
                        theme: ThemeData(
                            primarySwatch: AppColors.primaryMaterialColor,
                            brightness: isDarkTheme!
                                ? Brightness.dark
                                : Brightness.light),
                        routes: AppController().appRouters(),
                        initialRoute: (isValidToken) ? '/home' : '/',
                      );
                    }
                    return MaterialApp(
                      theme: ThemeData(
                          primarySwatch: AppColors.primaryMaterialColor,
                          brightness: appController.isDarkTheme
                              ? Brightness.dark
                              : Brightness.light),
                      routes: AppController().appRouters(),
                      initialRoute: (isValidToken) ? '/home' : '/',
                    );
                  },
                );
              }

              return Container(
                color: AppColors.secondaryColor,
                child: const Directionality(
                  textDirection: TextDirection.ltr,
                  child: Center(
                    child: Text(
                      'Erro no servidor',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}
