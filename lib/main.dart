import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fashion Detector',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;
  String _detectedItem;
  bool _isLoading = false;

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _imageFile = image;
    });
  }

  Future getDownloadUrl(BuildContext context) async {

    setState(() {
      _isLoading = true;
    });

    String fileId = randomAlpha(5);


    StorageReference reference =
        FirebaseStorage.instance.ref().child("$fileId.jpg");
    StorageUploadTask uploadTask = reference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();


    final Map<String, dynamic> requestData = {"input": downloadUrl};
    var url = "https://fashionpredict.herokuapp.com/predict";
    final http.Response response =
        await http.post(url, body: json.encode(requestData), headers: {
      'Content-Type': 'application/json',
    });

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    if (responseData['status']['code'] == 10000) {
      String detectedItem =
          responseData['outputs'][0]['data']['concepts'][0]['name'];
      setState(() {
        _detectedItem = detectedItem;
      });
    }
    setState(() {
      _isLoading = false;
    });
    _showResponse(context);
  }

  void _showResponse(context) {
    showModalBottomSheet(
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                _detectedItem == null
                    ? Text('Sorry, there was an error. Please try again.')
                    : Column(children: <Widget>[
                        Text(
                          'Detected Items',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          _detectedItem,
                          style: TextStyle(fontSize: 20.0),
                        )
                      ]),
                SizedBox(height: 15.0,),
                RaisedButton(
                  color: Colors.amber,
                  child: Text('Dismiss', style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    setState(() {
                      _imageFile = null;
                      _detectedItem = null;
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fashion Detector'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment(0.0, 0.0),
                width: 300.0,
                child: Text('Welcome to Fashion Detector.'),
              ),
              Container(
                alignment: Alignment(0.0, 0.0),
                width: 300.0,
                child: Text(
                  'Please capture a new Image or pick one from the gallery to continue.',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      getImage(false);
                    },
                    icon: Icon(Icons.insert_drive_file),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  IconButton(
                    onPressed: () {
                      getImage(true);
                    },
                    icon: Icon(Icons.camera_alt),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              _imageFile == null
                  ? Container()
                  : Image.file(
                      _imageFile,
                      height: 300.0,
                      width: 300.0,
                    ),
              SizedBox(
                height: 15.0,
              ),
              _imageFile == null
                  ? Container()
                  : _isLoading == true ? CircularProgressIndicator() : RaisedButton(
                      onPressed: () {
                        getDownloadUrl(context);
                      },
                      child: Text(
                        'Detect Fashion Items',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).accentColor,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
