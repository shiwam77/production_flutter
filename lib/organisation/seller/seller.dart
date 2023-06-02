import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../payment.dart';
import '../service/organisation_auth.dart';

class SellerInfo extends StatefulWidget {
  const SellerInfo({super.key});

  @override
  _SellerInfoState createState() => _SellerInfoState();
}

class _SellerInfoState extends State<SellerInfo> {
  OrganisationAuth authService = OrganisationAuth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seller Requext',
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
      body: Column(
        children: [sellerRequestBuilder()],
      ),
    );
  }

  Widget sellerRequestBuilder() {
    return Expanded(
      child: StreamBuilder(
        stream: authService.checkout
            .where('organisation_id', isEqualTo: authService.currentUser!.uid)
            .where('status', isEqualTo: 'Reject')
            .where("status", isNotEqualTo: 'Bought')
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
              if (snapshot.data!.docs.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot item = snapshot.data!.docs[index];
                    var waste = item['checkout_waste'];

                    return ExpansionTile(
                      collapsedTextColor: Color(0xFF89cc4f),
                      collapsedIconColor: Color(0xFF89cc4f),
                      title: Row(
                        children: [
                          Text(
                            item['user_detail']['name'],
                            style: const TextStyle(
                                fontSize: 20.0,
                                color: Color(0xFF89cc4f),
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
                          ),
                          Spacer(),
                          TextButton(
                              onPressed: () {
                                int totalPrice = 0;
                                waste.forEach((value) {
                                  print(value['quantity']);
                                  String? price = calculatePrice(
                                      value['quantity'],
                                      value['waste_type'],
                                      item);
                                  totalPrice = totalPrice + int.parse(price!);
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentGateWay(
                                            item: item,
                                            price: totalPrice,
                                          )),
                                );
                              },
                              child: Text("Buy")),
                          TextButton(
                              onPressed: () async {
                                await authService.checkout
                                    .doc(item.id)
                                    .update({'status': 'Rejected'});
                              },
                              child: Text("Reject")),
                        ],
                      ),
                      children: <Widget>[
                        ...List.generate(waste.length, (index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: item['status'] == "Pending"
                                  ? Colors.yellow.withOpacity(0.2)
                                  : item['status'] == "Acknowledged"
                                      ? Color(0xFF89cc4f).withOpacity(0.2)
                                      : Colors.blue.withOpacity(0.2),
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      waste[index]['waste_type'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['status'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: waste[index]['status'] == "Pending"
                                          ? Colors.yellow
                                          : waste[index] == "Acknowledged"
                                              ? Colors.green
                                              : Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    waste[index]['waste_description'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              trailing: Image.network(waste[index]['image']),
                            ),
                          );
                        })
                      ],
                    );
                  },
                );
              } else {
                return Center(child: Text('No Seller Request'));
              }
            } else {
              return const Text('No Seller Request');
            }
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }

  String? calculatePrice(int quantity, String type, DocumentSnapshot item) {
    if (type == 'Kitchen Waste') {
      return (quantity *
              int.parse(item['organisation_detail']['price']['Kitchen_waste']))
          .toString();
    } else if (type == 'Plastic') {
      return (quantity *
              int.parse(item['organisation_detail']['price']['Plastic']))
          .toString();
    } else if (type == 'Paper') {
      return (quantity *
              int.parse(item['organisation_detail']['price']['Paper']))
          .toString();
    } else if (type == 'Metal') {
      return (quantity *
              int.parse(item['organisation_detail']['price']['Metal']))
          .toString();
    } else if (type == 'Glass') {
      return (quantity *
              int.parse(item['organisation_detail']['price']['Glass']))
          .toString();
    } else {
      return null;
    }
  }
}

class HistoryItem {
  String title;
  String message;
  DateTime time;
  String status;

  HistoryItem({
    required this.title,
    required this.message,
    required this.time,
    this.status = 'Acknowledged',
  });
}
