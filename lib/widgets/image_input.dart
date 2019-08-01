import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

enum ImageFrom { Gallery, Camera }

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<ImageFrom> _takeImageFrom() async {
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text('Choose a resource'),
        message: Text('message'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop(ImageFrom.Camera);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              Navigator.of(context).pop(ImageFrom.Gallery);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future _takePicture() async {
    File imageFile;

    final ImageFrom imageFrom = await _takeImageFrom();
    if (imageFrom == null) {
      return;
    }
    if (imageFrom == ImageFrom.Camera) {
      imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
    }
    if (imageFrom == ImageFrom.Gallery) {
      imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
      );
    }

    if (imageFile == null) {
      // left camera without take a image
      // will return null
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Row(
        children: <Widget>[
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.blueGrey,
              ),
            ),
            child: _storedImage != null
                ? Image.file(
                    _storedImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Text(
                    'No Image Taken',
                    textAlign: TextAlign.center,
                  ),
            alignment: Alignment.center,
          ),
          SizedBox(width: 10),
          Expanded(
            child: FlatButton.icon(
              icon: Icon(Icons.camera),
              label: Text('Take Picture'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _takePicture,
            ),
          ),
        ],
      ),
    );
  }
}
