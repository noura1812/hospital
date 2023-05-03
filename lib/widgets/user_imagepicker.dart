import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hospital/theme.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFun;

  const UserImagePicker(this.imagePickFun, {super.key});
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future pickimages() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      image == null ? null : _pickedImage = File(image.path);
    });
    _pickedImage == null ? null : widget.imagePickFun(_pickedImage!);
  }

  Future pickimagesgalry() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image == null ? null : _pickedImage = File(image.path);
    });

    _pickedImage == null ? null : widget.imagePickFun(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            dialog();
          },
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage: _pickedImage != null
                ? FileImage(_pickedImage!)
                : const AssetImage('assets/images/personal photo.png')
                    as ImageProvider,
          ),
        ),
      ],
    );
  }

  dialog() {
    showDialog(
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () async => pickimages(),
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Themes.lightblue,
                    )),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Camera',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Themes.lightblue, fontSize: 15),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () async => pickimagesgalry(),
                    icon: const Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: Themes.lightblue,
                    )),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Gallery',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Themes.lightblue, fontSize: 15),
                )
              ],
            )
          ],
        ),
      ),
      context: context,
    );
  }
}
