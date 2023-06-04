import 'package:flutter/material.dart';
import 'package:production_flutter/scan_your_waste.dart';

class RecommendsWaste extends StatelessWidget {
  const RecommendsWaste({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          RecommendedWasteCard(
            image: "image/plasticbb.png",
            title: "Plastic",
            product: "Bottle",
            price: 25,
            press: () {},
            buttonTitle: "Sell Now",
            onPressButton: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanYourWaste()),
              );
            },
          ),
          RecommendedWasteCard(
            image: "image/cardboard.png",
            title: "cardboard",
            product: "Box",
            price: 25,
            press: () {},
            buttonTitle: "Sell Now",
            onPressButton: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanYourWaste()),
              );
            },
          ),
          RecommendedWasteCard(
            image: "image/metalCan.jpg",
            title: "Metal",
            product: "Can",
            price: 25,
            press: () {},
            buttonTitle: "Sell Now",
            onPressButton: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanYourWaste()),
              );
            },
          ),
          RecommendedWasteCard(
            image: "image/foodwaste.png",
            title: "Organic",
            product: "Food",
            price: 25,
            press: () {},
            buttonTitle: "Sell Now",
            onPressButton: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanYourWaste()),
              );
            },
          ),
          RecommendedWasteCard(
            image: "image/laptop.png",
            title: "Electronic",
            product: "Laptop",
            price: 25,
            press: () {},
            buttonTitle: "Sell Now",
            onPressButton: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanYourWaste()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecommendedWasteCard extends StatelessWidget {
  const RecommendedWasteCard({
    super.key,
    required this.image,
    required this.title,
    required this.product,
    required this.price,
    required this.press,
    required this.buttonTitle,
    required this.onPressButton,
  });

  final String image, title, product;
  final int price;
  final VoidCallback press;
  final String buttonTitle;
  final VoidCallback onPressButton;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        bottom: 50,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Image.asset(
            image,
            width: 200, // Set the desired width
            height: 140,
          ),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: const Color(0xFF89cc4f).withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "$title\n".toUpperCase(),
                        style: Theme.of(context).textTheme.button,
                      ),
                      TextSpan(
                          text: "$product\n".toUpperCase(),
                          style: TextStyle(
                            color: const Color(0xFF89cc4f).withOpacity(0.5),
                          )),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onPressButton,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0xFF89cc4f),
            ),
            child: Text(buttonTitle),
          ),
        ],
      ),
    );
  }
}
