import 'package:flutter/material.dart';
import 'average_hash.dart';
import 'difference_hash.dart';
import 'package:image/image.dart' as imageLib; // Naming conflict with internal Image color class
import 'package:http/http.dart' as http;
import 'dart:typed_data';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Hashing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Image Hashing demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<Uint8List> downloadImageBytes(String url) async {
  http.Client client = new http.Client();
  var req = await client.get(Uri.parse(url));
  var bytes = req.bodyBytes;
  return bytes;
}

class _MyHomePageState extends State<MyHomePage> {

  int difference = 0;

  var isSwitched = false;

  Uint8List firstImage = new Uint8List(0);
  Uint8List secondImage = new Uint8List(0);
  Uint8List similarImage = new Uint8List(0);

  Uint8List currentSecondImage = new Uint8List(0);

  @override
  void initState() {
    super.initState();

    loadImages();
  }

  void loadImages() async {
    await downloadImageBytes(
        'https://www.revealedrecordings.com/uploads/image/5ba8a853c6e190231017d1b6.jpg')
        .then((value) =>
        setState(() {
          firstImage = value;
        }));

    await downloadImageBytes(
        'https://www.revealedrecordings.com/uploads/image/5baa132ec6e190473b3a9fa6.jpg')
        .then((value) =>
        setState(() {
          secondImage = value;
          currentSecondImage = value;
        }));

    await downloadImageBytes(
        'https://www.revealedrecordings.com/uploads/image/5ba502dcc6e1908124391f48.jpg')
        .then((value) =>
        setState(() {
          similarImage = value;
        }));

    difference = DifferenceHash().compare(imageLib.decodeImage(firstImage), imageLib.decodeImage(currentSecondImage));
  }

  void _onChangedImage(bool value) {
    setState(() {
      isSwitched = value;

      if (value) {
        currentSecondImage = similarImage;
      } else {
        currentSecondImage = secondImage;
      }
      difference = DifferenceHash().compare(imageLib.decodeImage(firstImage), imageLib.decodeImage(currentSecondImage));
    });
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Switch(value: isSwitched, onChanged: _onChangedImage),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.memory(firstImage, width: 150.0, height: 150.0),
                  Image.memory(currentSecondImage, width: 150.0, height: 150.0)
                ],
              ),
              Text(
                'Difference: $difference',
                style: new TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      );
    }
}
