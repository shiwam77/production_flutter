import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:production_flutter/service/auth.dart';
import 'package:production_flutter/service/user_service.dart';
import 'package:production_flutter/trade/trade_checkout.dart';

import '../search_organization.dart';

class MyWasteList extends StatefulWidget {
  final Organisation organisation;
  const MyWasteList({super.key, required this.organisation});

  @override
  _MyWasteListState createState() => _MyWasteListState();
}

class _MyWasteListState extends State<MyWasteList> {
  Auth authService = Auth();
  UserService userService = UserService();
  List<DocumentSnapshot> myWaste = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Waste',
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
      body: Column(
        children: [
          myWasteBuilder(),
        ],
      ),
      floatingActionButton: Container(
        width: size.width * 0.8,
        child: FloatingActionButton.extended(
          onPressed: () async {
            try {
              if (myWaste.isNotEmpty) {
                userService.getUserData().then((value) {
                  Map<String, dynamic> data =
                      value.data() as Map<String, dynamic>;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TradeCheckOut(
                              myWaste: myWaste,
                              userData: data,
                              organisation: widget.organisation,
                            )),
                  );
                });
              }
            } catch (e) {
              print(e);
            }
          },
          icon: const Icon(Icons.sell_outlined, color: Colors.black),
          label: const Text(
            'Trade',
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

  Widget myWasteBuilder() {
    return Expanded(
      child: StreamBuilder(
        stream: authService.carts
            .where('user_id', isEqualTo: userService.user!.uid)
            .where('sold', isEqualTo: false)
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              myWaste = snapshot.data!.docs;

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot item = snapshot.data!.docs[index];
                  return Card(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(
                        item['waste_type'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () async {
                              int quantity = item['quantity'];
                              if (quantity > 1) {
                                quantity--;
                                await authService.carts
                                    .doc(item.id)
                                    .update({'quantity': quantity});
                              }
                            },
                          ),
                          Text(
                            '${item['quantity']}kg',
                            style: const TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              int quantity = item['quantity'];
                              quantity++;
                              await authService.carts
                                  .doc(item.id)
                                  .update({'quantity': quantity});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              loadingDialogBox(context, 'deleting');

                              FirebaseFirestore.instance.runTransaction(
                                  (Transaction myTransaction) async {
                                await myTransaction.delete(
                                    snapshot.data!.docs[index].reference);
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
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class SellItem {
  final String name;
  int quantity;

  SellItem({required this.name, required this.quantity});
}
