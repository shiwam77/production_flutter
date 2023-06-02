import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/material.dart';
import 'package:production_flutter/organisation/service/organisation_auth.dart';

import '../location_screen.dart';
import 'home/home.dart';

class PaymentGateWay extends StatelessWidget {
  final DocumentSnapshot item;
  final int price;
  const PaymentGateWay({Key? key, required this.item, required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrganisationAuth authService = OrganisationAuth();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor:
            Color(0xFF89cc4f).withOpacity(0.8), // Transparent green color
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Add the navigation logic here
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            const LargeHeadingWidget(
                heading: 'Payment GateWay',
                subheadingTextSize: 16,
                headingTextSize: 30,
                subHeading:
                    'As of now,We are only providing esewa payment gateWay '),
            SizedBox(
              height: 200,
            ),
            EsewaPayButton(
              paymentConfig: ESewaConfig.dev(
                su: 'https://www.marvel.com/hello',
                amt: double.parse(price.toString()),
                fu: 'https://www.marvel.com/hello',
                pid: DateTime.now().toIso8601String(),
              ),
              width: 100,
              onFailure: (result) async {},
              onSuccess: (result) async {
                loadingDialogBox(context, 'Updating Database');

                authService.checkout
                    .doc(item.id)
                    .update({'status': 'Bought'}).then((value) {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      OrganisationHome.screenId, (route) => false);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
