import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../check_out.dart';
import '../service/auth.dart';
import '../service/user_service.dart';

class OrganisationList extends StatelessWidget {
  final List<DocumentSnapshot> myWaste;
  final Map<String, dynamic> userData;
  const OrganisationList(
      {Key? key, required this.myWaste, required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Near by recyclable waste collection centers',
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
      body: OrganisationListBody(
        myWaste: myWaste,
        userData: userData,
      ),
    );
  }
}

class OrganisationListBody extends StatefulWidget {
  final List<DocumentSnapshot> myWaste;
  final Map<String, dynamic> userData;
  const OrganisationListBody(
      {Key? key, required this.myWaste, required this.userData})
      : super(key: key);

  @override
  State<OrganisationListBody> createState() => _OrganisationListBodyState();
}

class _OrganisationListBodyState extends State<OrganisationListBody> {
  Auth authService = Auth();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        myOrganisationBuilder(),
      ],
    );
  }

  Widget myOrganisationBuilder() {
    return Expanded(
      child: StreamBuilder(
        stream: authService.organisation.snapshots(),
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
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot item = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckOut(
                                  myWaste: widget.myWaste,
                                  userData: widget.userData,
                                  organisation: item,
                                )),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                    color: Color(0xFF89cc4f), fontSize: 16),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  Text(
                                    "Glass :${item['price']['Glass']}rs/kg",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Plastic :${item['price']['Plastic']}rs/kg",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Metal :${item['price']['Metal']}rs/kg",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Paper :${item['price']['Paper']}rs/kg",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Kitchen_waste :${item['price']['Kitchen_waste']}rs/kg",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: item['image'].toString().isNotEmpty
                              ? Image.network(item['image'])
                              : null,
                        ),
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
