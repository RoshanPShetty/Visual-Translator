import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool uploading = false;
  String parsedText = '';

  parseGalleryText() async {
    // Step 1: Picking the image using ImagePicker
    final imageFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 670, maxHeight: 970);

    // Step 2: Prepare the image
    setState(() {
      uploading = true;
    });
    var bytes = File(imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    // Step 3: Send the image to the API
    var url = 'https://api.ocr.space/parse/image';
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apikey": "123c32741288957"};
    var post = await http.post(url, body: payload, headers: header);

    // Step 4: Retrieve the image from the API
    var result = jsonDecode(post.body);
    setState(() {
      uploading = false;
      parsedText = result['ParsedResults'][0]['ParsedText'];
    });
  }

  parseCameraText() async {
    // Step 1: Picking the image using ImagePicker
    final imageFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxWidth: 670, maxHeight: 970);

    // Step 2: Prepare the image
    setState(() {
      uploading = true;
    });
    var bytes = File(imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    // Step 3: Send the image to the API
    var url = 'https://api.ocr.space/parse/image';
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apikey": "123c32741288957"};
    var post = await http.post(url, body: payload, headers: header);

    // Step 4: Retrieve the image from the API
    var result = jsonDecode(post.body);
    setState(() {
      uploading = false;
      parsedText = result['ParsedResults'][0]['ParsedText'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visual Translator',
          style:
              GoogleFonts.montserrat(fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            uploading == false ? Container() : CircularProgressIndicator(),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'Parsed Text: ',
                    style: GoogleFonts.montserrat(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 1.5,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Center(
                child: Text(
                  parsedText,
                  style: GoogleFonts.montserrat(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => parseGalleryText(),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        'Gallery',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () => parseCameraText(),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        'Camera',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
