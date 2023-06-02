import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:production_flutter/organisation/service/organisation_auth.dart';

class OrganisationHistory extends StatefulWidget {
  const OrganisationHistory({super.key});

  @override
  _OrganisationHistoryState createState() => _OrganisationHistoryState();
}

class _OrganisationHistoryState extends State<OrganisationHistory> {
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
            .where("status", isEqualTo: 'Bought')
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
                      title: Text(
                        item['user_detail']['name'],
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF89cc4f),
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
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
                return Center(child: Text('No History'));
              }
            } else {
              return const Text('No History');
            }
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
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
