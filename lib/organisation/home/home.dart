import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:production_flutter/color.dart';
import 'package:production_flutter/search_organization.dart';

import '../auth/login.dart';
import '../organisation_hostory.dart';
import '../payment.dart';
import '../seller/seller.dart';
import '../service/organisation_auth.dart';
import 'organisation_profile.dart';

class OrganisationHome extends StatefulWidget {
  static const String screenId = 'organisation_home';

  const OrganisationHome({Key? key}) : super(key: key);

  @override
  _OrganisationHomeState createState() => _OrganisationHomeState();
}

Widget _buildCategoryProduct({required String image, required int color}) {
  return Container(
    alignment: Alignment.center,
    child: CircleAvatar(
      maxRadius: 39,
      backgroundColor: Color(color),
      child: SizedBox(
        height: 45,
        child: Image(
          color: Colors.white,
          image: AssetImage("image/$image"),
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}

class _OrganisationHomeState extends State<OrganisationHome> {
  DrawerSections currentPage = DrawerSections.profile;
  OrganisationAuth authService = OrganisationAuth();
  late Future initUserDetail;

  Map<String, dynamic> userData = {};
  static List<Organisation> products = [];

  @override
  void initState() {
    // TODO: implement initState
    User? user = FirebaseAuth.instance.currentUser;
    initUserDetail = authService.getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget container;
    if (currentPage == DrawerSections.profile) {
      container = OrganisationProfilePage();
    } else if (currentPage == DrawerSections.seller) {
      container = const SellerInfo();
    } else if (currentPage == DrawerSections.history) {
      container = const OrganisationHistory();
    } else if (currentPage == DrawerSections.logout) {
      container = const OrganizationLogin();
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFF89cc4f),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              myHeaderDrawer(),
              MyDrawerList(),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: initUserDetail,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return customSnackBar(
                    context: context, content: "Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                userData.clear();
                userData.addAll(data);
                return Container(
                  height: size.height * 0.2,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                          left: 25.0,
                          right: 10.0,
                          top: 25.0,
                          bottom: 40.0,
                        ),
                        height: size.height * 0.2 - 27,
                        decoration: const BoxDecoration(
                          color: Color(0xFF89cc4f),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(36),
                            bottomRight: Radius.circular(36),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: size.width * .6,
                              child: Text(
                                'Hi ${data['name']}!',
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            data['image'].toString().isEmpty
                                ? Image.asset("image/userlogo.png")
                                : Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              data['image'].toString()),
                                          fit: BoxFit.fill),
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: secondaryColor,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Seller Request",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(50, 23)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF89cc4f)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SellerInfo()),
                    );
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          sellerRequestBuilder(),
        ],
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
            .limit(10)
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

  Widget myHeaderDrawer() {
    return Container(
      color: Colors.green[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 60.0),
      child: FutureBuilder(
        future: initUserDetail,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return customSnackBar(
                context: context, content: "Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            userData.clear();
            userData.addAll(data);
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: data['image'].toString().isEmpty
                          ? const DecorationImage(
                              image: AssetImage('image/userlogo.png'),
                            )
                          : DecorationImage(
                              image: NetworkImage(data['image'].toString()))),
                ),
                Text(
                  data['name'].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  data['email'].toString(),
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 14,
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          menuItem(DrawerSections.profile, "Profile", Icons.person_2_outlined),
          menuItem(DrawerSections.seller, "Seller Request",
              Icons.production_quantity_limits),
          menuItem(DrawerSections.history, "History", Icons.history_outlined),
          menuItem(DrawerSections.logout, "Logout", Icons.logout_outlined),
        ],
      ),
    );
  }

  Widget menuItem(
    DrawerSections section,
    String title,
    IconData icon,
  ) {
    bool selected = currentPage == section;
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentPage = section;
          });
          navigateToPage(section);
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(icon, size: 20, color: Colors.black),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigateToPage(DrawerSections section) async {
    // Perform navigation to the selected page
    // You can use a navigation library like Navigator to navigate to the desired page
    switch (section) {
      case DrawerSections.profile:
        // Navigate to the profile page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrganisationProfilePage()),
        );
        break;
      case DrawerSections.seller:
        // Navigate to the My Waste page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SellerInfo()),
        );
        break;
      case DrawerSections.history:
        // Navigate to the history page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrganisationHistory()),
        );
        break;
      case DrawerSections.logout:
        // Navigate to the contact page
        FirebaseAuth.instance.signOut().then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrganizationLogin()),
          );
        });

        break;
    }
  }
}

enum DrawerSections {
  profile,
  seller,
  history,
  notification,
  logout,
}

class RecommendedTitle extends StatelessWidget {
  const RecommendedTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          Text(
            "Seller Request",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SellerInfo(),
          ),
        ],
      ),
    );
  }
}

class CategoryTitle extends StatelessWidget {
  const CategoryTitle({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(right: 20.0 / 4),
              height: 7,
              // color: Color(0xFF89cc4f).withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWithSearchBox extends StatelessWidget {
  const HeaderWithSearchBox({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
