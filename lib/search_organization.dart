import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:production_flutter/service/auth.dart';
import 'package:production_flutter/trade/my_waste_list.dart';
import 'package:search_page/search_page.dart';

class Search {
  static searchQueryPage(
      {required BuildContext context,
      required List<Organisation> organisation,
      required Map<String, dynamic> userData}) {
    showSearch(
      context: context,
      delegate: SearchPage<Organisation>(
          barTheme: ThemeData(
              appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF89cc4f),
                  elevation: 0,
                  surfaceTintColor: Color(0xFF89cc4f),
                  iconTheme: IconThemeData(color: Colors.white),
                  actionsIconTheme: IconThemeData(color: Color(0xFF89cc4f)))),
          onQueryUpdate: (s) => print(s),
          items: organisation,
          searchLabel: 'Search organisation...',
          suggestion: SingleChildScrollView(
              child: ProductListing(
            userData: userData,
          )),
          failure: const Center(
            child: Text('No organisation found, Please check and try again..'),
          ),
          filter: (product) => [
                product.name,
              ],
          builder: (product) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyWasteList(
                            organisation: product,
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
                          product.name.toString(),
                          style:
                              TextStyle(color: Color(0xFF89cc4f), fontSize: 16),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            Text(
                              "Glass :${product.price!.glass}rs/kg",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Plastic :${product.price!.plastic}rs/kg",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Metal :${product.price!.metal}rs/kg",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Paper :${product.price!.paper}rs/kg",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Kitchen :${product.price!.kitchenWaste}rs/kg",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Address ${product.address}",
                          style: const TextStyle(
                              color: Color(0xFF89cc4f), fontSize: 10),
                        ),
                      ],
                    ),
                    trailing: product.image.toString().isNotEmpty
                        ? Image.network(product.image.toString())
                        : null,
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class ProductListing extends StatefulWidget {
  final bool? isProductByCategory;
  final Map<String, dynamic> userData;
  const ProductListing(
      {Key? key, this.isProductByCategory, required this.userData})
      : super(key: key);

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  Auth authService = Auth();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: authService.organisation
            .where('addressOne', isEqualTo: widget.userData['addressOne'])
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products..'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF89cc4f),
              ),
            );
          }
          return (snapshot.data!.docs.isEmpty)
              ? SizedBox(
                  height: MediaQuery.of(context).size.height - 50,
                  child: const Center(
                    child: Text('No Products Found.'),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (widget.isProductByCategory != null)
                          ? const SizedBox()
                          : const Column(
                              children: [
                                Text(
                                  'Recommendation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black38,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            var item = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                              color: Color(0xFF89cc4f),
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
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
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Address ${item['address']}",
                                          style: const TextStyle(
                                              color: Color(0xFF89cc4f),
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    trailing:
                                        item['image'].toString().isNotEmpty
                                            ? Image.network(item['image'])
                                            : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
        });
  }
}

class Organisation {
  String? id;
  String? name;
  String? image;
  String? address;
  String? email;
  String? location;
  Price? price;
  Organisation(
      {this.id,
      this.image,
      this.email,
      this.name,
      this.location,
      this.address,
      this.price});
}

class Price {
  String? plastic;
  String? metal;
  String? glass;
  String? paper;
  String? kitchenWaste;
  Price({this.glass, this.kitchenWaste, this.metal, this.paper, this.plastic});
}
