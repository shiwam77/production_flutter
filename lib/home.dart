import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:production_flutter/color.dart';
import 'package:production_flutter/history.dart';
import 'package:production_flutter/login.dart';
import 'package:production_flutter/myWaste.dart';
import 'package:production_flutter/notification.dart';
import 'package:production_flutter/profile.dart';
import 'package:production_flutter/recommend_waste.dart';
import 'package:production_flutter/scan_your_waste.dart';
import 'package:production_flutter/search_organization.dart';
import 'package:production_flutter/service/auth.dart';
import 'package:production_flutter/service/user_service.dart';
import 'package:production_flutter/utils.dart';

import 'Setlocation.dart';

class MyHome extends StatefulWidget {
  static const String screenId = 'home';

  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

Widget _buildCategoryProduct({required String image, required int color}) {
  return Container(
    alignment: Alignment.center,
    child: CircleAvatar(
      maxRadius: 39,
      backgroundColor: Color(color),
      child: Container(
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

class _MyHomeState extends State<MyHome> {
  DrawerSections currentPage = DrawerSections.profile;
  Auth authService = Auth();
  UserService firebaseUser = UserService();
  late Future initUserDetail;
  late Future initUserLocation;

  Map<String, dynamic> userData = {};
  static List<Organisation> products = [];

  @override
  void initState() {
    // TODO: implement initState
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User? user = FirebaseAuth.instance.currentUser;
    initUserLocation = users.doc(user!.uid).get();
    initUserDetail = firebaseUser.getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget container;
    if (currentPage == DrawerSections.profile) {
      container = ProfilePage();
    } else if (currentPage == DrawerSections.scanWaste) {
      container = const ScanYourWaste();
    } else if (currentPage == DrawerSections.myWaste) {
      container = MyWastePage();
    } else if (currentPage == DrawerSections.notification) {
      container = NotificationPage();
    } else if (currentPage == DrawerSections.history) {
      container = HistoryPage();
    } else if (currentPage == DrawerSections.logout) {
      container = MyLogin();
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
        actions: [
          InkWell(
            onTap: () {
              authService.organisation.get().then(((snapshot) {
                snapshot.docs.forEach((doc) {
                  products.add(Organisation(
                    id: doc.id,
                    name: doc['name'],
                    address: doc['address'],
                    image: doc['image'],
                    email: doc['email'],
                    price: Price(
                      glass: doc["price"]['Glass'],
                      metal: doc["price"]['Metal'],
                      plastic: doc["price"]['Plastic'],
                      kitchenWaste: doc["price"]['Kitchen_waste'],
                      paper: doc["price"]['Paper'],
                    ),
                  ));
                });
                Search.searchQueryPage(
                    userData: userData,
                    context: context,
                    organisation: products);
              }));
            },
            child: const CircleAvatar(
              radius: 17,
              backgroundColor: Color(0xFFbde29c),
              child: Icon(Icons.search, size: 21, color: Colors.black),
            ),
          ),
          InkWell(
            onTap: () {
              // authService.organisation.doc().set({
              //   'name': "Waste Culture Pokhara",
              //   'email': 'wasteculturePokhara@gmail.com',
              //   'mobile': '',
              //   'address': 'Pokhara, 33800',
              //   'addressOne': 'Pokhara',
              //   'location': GeoPoint(28.237987, 83.995588),
              //   'image':
              //       'https://whatdesigncando.s3.eu-central-1.amazonaws.com/app/uploads/20210120101404/iStock-927987734-1440x959.jpg',
              //   'price': {
              //     'Glass': "8",
              //     'Plastic': "10",
              //     'Metal': "10",
              //     'Paper': "12",
              //     'Kitchen_waste': "5",
              //   }
              // }).then((value) {
              //   print("done");
              // });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Color(0xFFbde29c),
                child: Icon(Icons.notifications, size: 21, color: Colors.black),
              ),
            ),
          ),
        ],
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
      body: SingleChildScrollView(
        child: Column(
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
                          padding: EdgeInsets.only(
                            left: 25.0,
                            right: 10.0,
                            top: 25.0,
                            bottom: 40.0,
                          ),
                          height: size.height * 0.2 - 27,
                          decoration: BoxDecoration(
                            color: Color(0xFF89cc4f),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Hi ${data['name']}!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
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

            /////////////////Location////////////
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: lcoationAutoFetchBar(context),
            ),

            /////////////////Category////////////
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CategoryTitle(
                    text: "Category",
                  ),
                  Spacer(),
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
                    onPressed: () {},
                    child: Text(
                      "See All",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              child: Row(
                children: <Widget>[
                  _buildCategoryProduct(
                      image: "organic1.png", color: 0xFF89cc4f),
                  _buildCategoryProduct(
                      image: "plastic.png", color: 0xFFF38cdd),
                  _buildCategoryProduct(
                      image: "electronic.png", color: 0xFFd2691e),
                  _buildCategoryProduct(image: "paper.png", color: 0xFF74acf7),
                  _buildCategoryProduct(image: "scrap.png", color: 0xFF33dcfd),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //////////////Recommended/////////////
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  RecommendedTitle(
                    text: 'Recommended',
                  ),
                  // Spacer(),
                  // ElevatedButton(
                  //   style: ButtonStyle(
                  //     minimumSize: MaterialStateProperty.all(Size(50, 23)),
                  //     shape: MaterialStateProperty.all(
                  //       RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //     ),
                  //     padding: MaterialStateProperty.all(
                  //       const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                  //     ),
                  //     backgroundColor:
                  //         MaterialStateProperty.all(Color(0xFF89cc4f)),
                  //   ),
                  //   onPressed: () {},
                  //   child: Text("See All",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 10,
                  //           color: Colors.black)),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            RecommendsWaste(),
          ],
        ),
      ),
    );
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

  Widget lcoationAutoFetchBar(BuildContext context) {
    return FutureBuilder(
      future: initUserLocation,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return customSnackBar(
              context: context, content: "Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return customSnackBar(
              context: context, content: "Addrress not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['address'] == null) {
            return InkWell(
                onTap: () {
                  String? address;
                  getLocationAndAddress(context).then((value) {
                    address = value;
                    getCurrentLocation(context, serviceEnabled, permission)
                        .then((geoPoint) {
                      if (value != null) {
                        String addressOne = address!.split(',').first;
                        firebaseUser.updateFirebaseUser(context, {
                          'location':
                              GeoPoint(geoPoint.latitude, geoPoint.longitude),
                          'address': address,
                          'addressOne': addressOne
                        }).then((value) {
                          setState(() {});
                        });
                      }
                    });
                  });
                },
                child: locationTextWidget(location: 'Update Location'));
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                locationTextWidget(location: data['address']),
                TextButton(
                  onPressed: () {
                    GeoPoint geoPoint = data['location'];
                    print(geoPoint);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetlocationPage(
                                lang: geoPoint.longitude,
                                lat: geoPoint.latitude,
                              )),
                    );
                  },
                  child: Text("View on map"),
                ),
              ],
            );
          }
        }
        return locationTextWidget(location: 'Fetching location');
      },
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
          menuItem(DrawerSections.scanWaste, "Scan your waste", Icons.scanner),
          menuItem(
              DrawerSections.myWaste, "My Waste", Icons.shopping_bag_outlined),
          menuItem(DrawerSections.notification, "Notification",
              Icons.notification_add_outlined),
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
                  style: TextStyle(
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
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case DrawerSections.myWaste:
        // Navigate to the My Waste page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyWastePage()),
        );
        break;
      case DrawerSections.scanWaste:
        // Navigate to the My Waste page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScanYourWaste()),
        );
        break;
      case DrawerSections.notification:
        // Navigate to the notification page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        );
        break;
      case DrawerSections.history:
        // Navigate to the history page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryPage()),
        );
        break;
      case DrawerSections.logout:
        // Navigate to the contact page
        FirebaseAuth.instance.signOut().then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyLogin()),
          );
        });

        break;
    }
  }
}

enum DrawerSections {
  profile,
  scanWaste,
  myWaste,
  history,
  notification,
  logout,
}

class RecommendedTitle extends StatelessWidget {
  const RecommendedTitle({
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
            "Recomended",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: 20.0 / 4),
              height: 7,
              // color: Color(0xFF89cc4f).withOpacity(0.2),
            ),
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
