import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/app/models/user.dart';
import 'package:mobile/app/services/user_service.dart';
import 'package:mobile/app/constants/app_colors.dart';
import 'package:mobile/app/views/android/components/delete_dialog.dart';
import 'package:mobile/app/views/android/components/toasts.dart';
import 'package:mobile/app/views/android/components/custom_field.dart';
import 'package:mobile/app/views/android/components/profile_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _selectedImage;
  final UserService _userService = UserService();

  Future<void> _selectImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(pickedImage.path);
      final filename = file.path.split('/').last;

      final MultipartFile multipartFile = await MultipartFile.fromPath(
        'image',
        file.path,
        filename: filename,
      );

      userService.uploadImage(multipartFile, context);

      setState(() {
        _selectedImage = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Future.delayed(const Duration(seconds: 0));
        setState(() {});
      },
      child: FutureBuilder<User?>(
        future: UserService().getUserLogged(context),
        builder: (context, snapshot) {
          final User? user = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      FutureBuilder(
                          future:
                              user != null && user.img != '' && user.img != null
                                  ? _userService.getProfileImg(context)
                                  : null,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              final imageBytes = snapshot.data!;
                              final image = Image.memory(
                                Uint8List.fromList(imageBytes),
                                width: 200,
                                height: 200,
                              );

                              return CircleAvatar(
                                radius: 100,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : image.image,
                              );
                            } else if (snapshot.data == null &&
                                (user?.img == '' || user?.img == null)) {
                              return CircleAvatar(
                                radius: 100,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                        as ImageProvider
                                    : const AssetImage(
                                        'assets/images/profile_photo.png'),
                              );
                            } else {
                              return const CircleAvatar(
                                radius: 100,
                              );
                            }
                          }),
                      InkWell(
                        onTap: _selectImageFromGallery,
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
                ),
                const SizedBox(
                  height: 40,
                ),
                customField('Nome: ', user?.name ?? ''),
                const Divider(
                  height: 40,
                ),
                customField('Email: ', user?.email ?? ''),
                const Divider(
                  height: 40,
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.secondaryColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  icon: const Icon(Icons.delete_forever),
                  label: const Text("Deletar conta"),
                  onPressed: () {
                    openDeleteDialog(() {
                      UserService().delete(context);
                    }, 'Sua conta será permanentemente exclúida e todos os seus imóveis cadastrados serão perdidos. Está ação é irreversível!',
                        context);
                  },
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.edit),
              onPressed: () async {
                if (user != null) {
                  openProfileDialog(context, user);
                } else {
                  Toasts().showError('Ocorreu um erro', context);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
