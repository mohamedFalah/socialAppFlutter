import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hello_flutter/services/firebase_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UploadCard extends StatefulWidget {
  @override
  _UploadCardState createState() => _UploadCardState();
}

class _UploadCardState extends State<UploadCard> {
  File imageFile;
  String _image;
  String caption = '';
  bool isImage = false;
  bool startUploading = false;
  double progress = 0.0;
  var firebaseServices = FirebaseServices();

  void pickImageFromGallery() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image.path;
      imageFile = File(image.path);
      isImage = true;
    });
  }

  void createPost() {
    firebaseServices.createPost(imageFile, caption, (progress) {
      setState(() {
        this.progress = progress;
      });
    }, (done) {
      setState(() {
        if (done) {
          startUploading = false;
          caption = '';
          isImage = false;
        }
      });
    }, () {
      print('error uploading');
    });
  }

  Widget progressBar() {
    return LinearPercentIndicator(
      lineHeight: 14.0,
      percent: progress,
      backgroundColor: Colors.grey,
      progressColor: Colors.blue,
    );
  }

  Widget imageIcon() {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(72, 76, 82, 0.16),
              offset: Offset(0, 8),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: IconButton(
          padding: EdgeInsets.all(4.0),
          icon: Icon(
            Icons.add_a_photo_rounded,
            size: 38.0,
          ),
          onPressed: () {
            pickImageFromGallery();
          },
        ));
  }

  Widget captionBox() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(72, 76, 82, 0.16),
                offset: Offset(0, 8),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              // maxLines: null,
              expands: false,
              style: TextStyle(
                fontSize: 13.0,
                color: Color(0xFF242629),
                decoration: TextDecoration.none,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Insert Caption',
                hintStyle: TextStyle(
                  fontSize: 13.0,
                  color: Color(0xFF797F8A),
                  decoration: TextDecoration.none,
                ),
              ),
              onChanged: (newCaption) {
                setState(() {
                  caption = newCaption;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadIcon() {
    return IconButton(
      iconSize: 50,
      icon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(72, 76, 82, 0.16),
              offset: Offset(0, 8),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Icon(
          Icons.publish_rounded,
          size: 38.0,
        ),
      ),
      onPressed: () {
        startUploading = true;
        if (_image != null) {
          createPost();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 1),
                  blurRadius: 3.0,
                ),
                BoxShadow(
                  color: Colors.blue[50],
                  offset: Offset(0, 1),
                  blurRadius: 3.0,
                ),
              ]),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                isImage
                    ? _image == null
                        ? Text("no Image yet")
                        : Image.file(
                            File(_image),
                            width: 38.0,
                            fit: BoxFit.fill,
                          )
                    : imageIcon(),
                SizedBox(
                  width: 6,
                ),
                captionBox(),
                SizedBox(
                  width: 6,
                ),
                uploadIcon()
              ],
            ),
          ),
        ),
        new Align(
          child: startUploading ? progressBar() : Container(),
        ),
      ],
    );
  }
}
