import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:production_flutter/color.dart';

import '../home.dart';
import '../sell_your_waste.dart';

class Loading extends StatelessWidget {
  final PickedFile image;
  const Loading({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF89cc4f).withOpacity(0.8),
      body: LoadingBody(
        image: image,
      ),
      floatingActionButton: Container(
        width: size.width * 0.8,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SellWaste(
                        image: image,
                      )),
            );
          },
          icon: const Icon(Icons.check_outlined, color: Colors.black),
          label: const Text(
            'Continue',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class LoadingBody extends StatelessWidget {
  final PickedFile image;
  const LoadingBody({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                alignment: Alignment.centerLeft,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF000000),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MyHome.screenId, (route) => false);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 220.0),
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Center(
            child: Text(
              'Oops!'
              ' Your waste can\'t be processed through our system learning,Thougn you can sell up your waste manually',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF000000),
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            ),
          )
        ],
      ),
    );
  }
}
