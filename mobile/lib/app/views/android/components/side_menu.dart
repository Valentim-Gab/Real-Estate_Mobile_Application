import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile/app/database/login_dao.dart';
import 'package:mobile/app/models/user.dart';
import 'package:mobile/app/services/user_service.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        FutureBuilder(
            future: _userService.getUserLogged(context),
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasData) {
                final User? user = snapshot.data;

                return UserAccountsDrawerHeader(
                    currentAccountPicture: getProfilePicture(user),
                    accountName: Text(
                      user?.name ?? 'Convidado',
                      style: const TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      user?.email ?? 'Sem registro de email',
                      style: const TextStyle(color: Colors.white),
                    ));
              }

              return const Placeholder();
            }),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Início'),
          subtitle: const Text('Tela de início'),
          onTap: () {
            Navigator.of(context).pushNamed('/home');
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Perfil'),
          onTap: () {
            Navigator.of(context).pushNamed('/profile');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Sair'),
          onTap: () {
            LoginDao().logout(context);
          },
        ),
      ]),
    );
  }

  Widget getProfilePicture(User? user) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(40),
      elevation: 5,
      shadowColor: Colors.black,
      child: FutureBuilder(
          future: user != null && user.img != '' && user.img != null
              ? _userService.getProfileImg(context)
              : null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final imageBytes = snapshot.data!;
              final image = Image.memory(
                Uint8List.fromList(imageBytes),
                fit: BoxFit.cover,
              );

              return ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: image,
                ),
              );
            } else if (snapshot.data == null &&
                user != null &&
                (user.img == null || user.img == '')) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Image.asset(
                        'assets/images/profile_photo.png',
                        fit: BoxFit.cover,
                      )));
            } else {
              return ClipRRect(borderRadius: BorderRadius.circular(40));
            }
          }),
    );
  }
}
