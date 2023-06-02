import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:production_flutter/search_organization.dart';
import 'package:production_flutter/service/auth.dart';
import 'package:production_flutter/service/user_service.dart';

import '../history.dart';
import '../home.dart';

class TradeCheckOut extends StatelessWidget {
  final List<DocumentSnapshot> myWaste;
  final Map<String, dynamic> userData;
  final Organisation organisation;
  const TradeCheckOut(
      {Key? key,
      required this.myWaste,
      required this.userData,
      required this.organisation})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CheckOut',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFF89cc4f),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Add the navigation logic here
          },
        ),
      ),
      body: CheckOutBody(
        myWaste: myWaste,
        userData: userData,
        organisation: organisation,
      ),
      floatingActionButton: Container(
        width: size.width * 0.8,
        child: FloatingActionButton.extended(
          onPressed: () async {
            Auth authService = Auth();
            UserService userService = UserService();
            Map<String, dynamic> checkout_waste = {};
            loadingDialogBox(context, 'Validating checkout');

            myWaste.forEach((item) async {
              await authService.carts.doc(item.id).update({'sold': true});
            });
            authService.checkout.doc().set({
              'user_id': userService.user!.uid.toString(),
              'organisation_id': organisation.id,
              'user_detail': userData,
              'status': 'inReview',
              'checkout_waste': List<dynamic>.from(myWaste.map((x) {
                return {
                  'id': x.id,
                  'user_id': x['user_id'],
                  'waste_type': x['waste_type'],
                  "waste_description": x['waste_description'],
                  'image': x['image'],
                  'quantity': x['quantity'],
                };
              })),
              'organisation_detail': {
                'uuid': organisation.id,
                'name': organisation.name,
                'email': organisation.email,
                'address': organisation.address,
                'image': organisation.image,
                'price': {
                  'Glass': organisation.price!.glass,
                  'Plastic': organisation.price!.plastic,
                  'Metal': organisation.price!.metal,
                  'Paper': organisation.price!.paper,
                  'Kitchen_waste': organisation.price!.kitchenWaste,
                }
              }
            }).then((value) {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(MyHome.screenId, (route) => false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
              print("done");
            });
          },
          icon: const Icon(Icons.check_outlined, color: Colors.black),
          label: const Text(
            'CheckOut',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Color(0xFF89cc4f),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CheckOutBody extends StatefulWidget {
  final List<DocumentSnapshot> myWaste;
  final Map<String, dynamic> userData;
  final Organisation organisation;

  const CheckOutBody(
      {Key? key,
      required this.myWaste,
      required this.userData,
      required this.organisation})
      : super(key: key);
  @override
  State<CheckOutBody> createState() => _CheckOutBodyState();
}

class _CheckOutBodyState extends State<CheckOutBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.organisation.name.toString(),
                      style: TextStyle(color: Color(0xFF89cc4f), fontSize: 16),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        Text(
                          "Glass :${widget.organisation.price!.glass}rs/kg",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Plastic :${widget.organisation.price!.plastic}rs/kg",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Metal :${widget.organisation.price!.metal}rs/kg",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Paper :${widget.organisation.price!.paper}rs/kg",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Kitchen_waste :${widget.organisation.price!.kitchenWaste}rs/kg",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Image.network(widget.organisation!.image.toString()),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: widget.myWaste.length,
            itemBuilder: (context, index) {
              DocumentSnapshot item = widget.myWaste[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    item['waste_type'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${item['quantity']}kg',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          loadingDialogBox(context, 'deleting');

                          FirebaseFirestore.instance.runTransaction(
                              (Transaction myTransaction) async {
                            await myTransaction
                                .delete(widget.myWaste[index].reference);
                          }).then((value) {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
