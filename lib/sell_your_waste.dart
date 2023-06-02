import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:production_flutter/service/auth.dart';
import 'package:production_flutter/service/user_service.dart';
import 'package:production_flutter/utils.dart';

import 'home.dart';
import 'myWaste.dart';

class Waste {
  String waste_name;
  String waste_type;
  Waste(this.waste_name, this.waste_type);
}

class SellWaste extends StatelessWidget {
  final PickedFile image;
  const SellWaste({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF89cc4f).withOpacity(0.8),
      body: SellWasteBody(
        image: image,
      ),
    );
  }
}

class SellWasteBody extends StatelessWidget {
  final PickedFile image;
  const SellWasteBody({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SellWasteHeader(size: size),
          SizedBox(
            height: 30.0,
          ),
          DropDownMenu(
            image: image,
          ), // TODO: add drop down menu (5)
          //TODO: text field
          // TODO: Remove -
          //TODO: next wala person

          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }
}

class TagsRow extends StatelessWidget {
  const TagsRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Row(
        children: [
          const Text(
            'Tags :',
            style: TextStyle(
                color: Color(0xFF4E4A4A),
                fontFamily: 'Nunito',
                fontSize: 20.0,
                fontWeight: FontWeight.normal),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            height: 30.0,
            decoration: BoxDecoration(
              color: Color(0xFFC4C4C4),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 0.0),
              child: Row(
                children: [
                  const Text(
                    'Plastic',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15.0,
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black,
                      size: 15.0,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            height: 30.0,
            decoration: BoxDecoration(
              color: Color(0xFFC4C4C4),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 0.0),
              child: Row(
                children: [
                  const Text(
                    'Paper',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15.0,
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black,
                      size: 15.0,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropDownMenu extends StatefulWidget {
  final PickedFile image;
  const DropDownMenu({Key? key, required this.image}) : super(key: key);

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String? _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: DropdownButton<String>(
        value: _chosenValue,
        //elevation: 5,
        style: const TextStyle(
          color: Color(0xFF4E4A4A),
          fontFamily: 'Nunito',
        ),

        items: <String>[
          'Plastic',
          'Paper',
          'Glass',
          'Kitchen Waste',
          'Metal',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: <Widget>[
                Text(value),
              ],
            ),
          );
        }).toList(),
        hint: Text(
          'Select your Waste',
          style: TextStyle(
              color: Color(0xFF4E4A4A),
              fontFamily: 'Nunito',
              fontSize: 20.0,
              fontWeight: FontWeight.normal),
        ),
        onChanged: (String? value) {
          // setState(() {
          _chosenValue = value;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  wasteType: value,
                  image: widget.image,
                );
                // });
              });
        },
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  var wasteType;
  final PickedFile image;
  CustomAlertDialog({Key? key, required this.wasteType, required this.image})
      : super(key: key);

  TextEditingController controller = TextEditingController();
  TextEditingController qualityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tell us what it is called?"),
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            TextField(
              cursorColor: const Color(0xFF8A8787),
              decoration: const InputDecoration(
                hintText: "Description",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8A8787),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8A8787),
                  ),
                ),
              ),
              controller: controller,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              cursorColor: const Color(0xFF8A8787),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Quantity (kg)",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8A8787),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8A8787),
                  ),
                ),
              ),
              controller: qualityController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            loadingDialogBox(context, 'Creating carts');
            String wasteName = controller.text;
            Auth authService = Auth();
            UserService userService = UserService();
            uploadFile(context, image.path).then((url) {
              if (url != null) {
                authService.carts.doc().set({
                  'user_id': userService.user!.uid.toString(),
                  'waste_type': wasteType,
                  "waste_description": wasteName,
                  'image': url,
                  'quantity': qualityController.text.isEmpty
                      ? 1
                      : int.parse(qualityController.text),
                  'sold': false
                }).then((value) async {
                  Navigator.pop(context);
                  customSnackBar(
                      context: context,
                      content: 'Add to My waste successfully');
                  Navigator.pop(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MyHome.screenId, (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyWastePage()),
                  );
                }).catchError((onError) {
                  Navigator.pop(context);
                  customSnackBar(
                      context: context,
                      content:
                          'Failed to add My waste to database, please try again $onError');
                  Navigator.pop(context);
                });
              }
            });
          },
          child: const Text(
            'Add to My Waste',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class SellWasteHeader extends StatelessWidget {
  const SellWasteHeader({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.6,
      child: Stack(
        children: [
          Container(
            height: size.height * 0.4,
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
            child: Image.asset("assets/images/SELL YOUR WASTE.png"),
          ),
          Positioned(
            bottom: 0,
            left: 20.0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 26.0),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 270.0,
                child: Text(
                  'Selling your waste creates employment, feeds a hungry kid, gives kids access to education and saves the environment. You also earn coins which can be redeemed to claim rewards. Sell your waste today and leave an indelible mark on the world.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
