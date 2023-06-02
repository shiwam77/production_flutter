import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:production_flutter/service/auth.dart';
import 'package:production_flutter/waste/glass_waste.dart';
import 'package:production_flutter/waste/kitchen_waste.dart';
import 'package:production_flutter/waste/loading.dart';
import 'package:production_flutter/waste/metal_waste.dart';
import 'package:production_flutter/waste/paper_waste.dart';
import 'package:production_flutter/waste/plastic_waste.dart';

class ScanYourWaste extends StatelessWidget {
  const ScanYourWaste({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF89cc4f).withOpacity(0.8),
      body: WatchYourWasteBody(),
    );
  }
}

class WatchYourWasteBody extends StatefulWidget {
  const WatchYourWasteBody({Key? key}) : super(key: key);

  @override
  State<WatchYourWasteBody> createState() => _WatchYourWasteBodyState();
}

class _WatchYourWasteBodyState extends State<WatchYourWasteBody> {
  bool _loading = true;
  List? _output;
  PickedFile? _image;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.5,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.5,
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 50.0,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/Login header BG.png"),
                  ),
                ),
                child: Image.asset("assets/images/WATCH YOUR WASTE.png"),
              ),
              Positioned(
                bottom: 0,
                left: 20.0,
                right: 0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 270.0,
                  // child: Icon(Icons.arrow_back_ios_outlined),
                ),
              ),
              Positioned(
                  bottom: 60, //TODO: position
                  left: 0,
                  right: 0,
                  child: TextButton.icon(
                    onPressed: () {
                      _showPicker(context);
                    },
                    icon: Image.asset("assets/images/Camera.png"),
                    label: Text(
                      '',
                    ),
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(
                    'Follow the following steps to know more about your waste',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(
                    'Follow the following steps to know more about your waste',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              ...List.generate(getSteps.length, (index) {
                return Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      getSteps[index].toString(),
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  List<String> getSteps = [
    "1.Select a single waste item",
    "2.Click on the camera icon to take a snap of your waste",
    "3.Recysell will segregate your waste into either plastic,glass,paper,kitchen waste,metals",
    "4.Hence inform you about the correct waste management practice",
  ];

  classifyImage(File image) async {
    loadingDialogBox(context, 'Validating your waste');
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 36,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    Navigator.pop(context);
    setState(() {
      _loading = false;
      _output = output;
      print(_output);
      var material;
      if (_output!.isEmpty) {
        material = "";
      } else {
        material = _output![0]['label'];
      }
      pageCall(material);
    });
  }

  void pageCall(String material) {
    if (material == "paper") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaperWaste(
                  image: _image!,
                )),
      );
    } else if (material == "plastic") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlasticWaste(image: _image!)),
      );
    } else if (material == "metal") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MetalWaste(image: _image!)),
      );
    } else if (material == "white-glass") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GlassWaste(image: _image!)),
      );
    } else if (material == "compost") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => KitchenWaste(image: _image!)),
      );
    } else {
      Tflite.close();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Loading(
                  image: _image!,
                )),
      );
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/WasteClassification.tflite",
      labels: "assets/labels.txt",
    );
  }

  _imgFromCamera() async {
    ImagePicker imagePicker = ImagePicker();
    final imageFile = await imagePicker.getImage(source: ImageSource.camera);
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.camera, imageQuality: 50
    // );

    setState(() {
      _image = imageFile;
    });
    classifyImage(File(_image!.path));
  }

  _imgFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    final imageFile = await imagePicker.getImage(source: ImageSource.gallery);
    // File image = await  ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 50
    // );

    setState(() {
      _image = imageFile;
    });

    classifyImage(File(_image!.path));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
