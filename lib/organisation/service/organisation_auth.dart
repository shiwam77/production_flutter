import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../color.dart';
import '../location.dart';

class OrganisationAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();
  User? currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference organisation =
      FirebaseFirestore.instance.collection('organisation');
  CollectionReference carts = FirebaseFirestore.instance.collection('cart');
  CollectionReference checkout =
      FirebaseFirestore.instance.collection('checkout');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  Future<void> updateFirebaseUser(
      BuildContext context, Map<String, dynamic> data) {
    User? user = FirebaseAuth.instance.currentUser;
    return organisation.doc(user!.uid).update(data).then((value) {
      customSnackBar(context: context, content: 'Location updated on database');
    }).catchError((error) {
      customSnackBar(
          context: context,
          content: 'location cannot be updated in database due to $error');
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await organisation.doc(currentUser!.uid).get();
    return doc;
  }

  Future<DocumentSnapshot> getAdminCredentialEmailAndPassword(
      {required BuildContext context,
      required String email,
      String? firstName,
      String? lastName,
      String? plastic,
      String? metal,
      String? glass,
      String? kitchen,
      String? paper,
      required String password,
      required bool isLoginUser}) async {
    DocumentSnapshot result = await organisation.doc(email).get();
    if (kDebugMode) {
      print(result);
    }
    try {
      if (isLoginUser) {
        print('loggin user');
        signInWithEmail(context, email, password);
      } else {
        if (result.exists) {
          customSnackBar(
              context: context,
              content: 'An account already exists with this email');
        } else {
          registerWithEmail(context, email, password, firstName!, lastName!,
              plastic!, metal!, glass!, kitchen!, paper!);
        }
      }
    } catch (e) {
      customSnackBar(context: context, content: e.toString());
    }
    return result;
  }

  signInWithEmail(BuildContext context, String email, String password) async {
    try {
      loadingDialogBox(context, 'Validating details');
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        print(credential);
      }
      Navigator.pop(context);
      if (credential.user!.uid != null) {
        Navigator.pushReplacementNamed(context, OrganisationLocation.screenId);
      } else {
        customSnackBar(
            context: context, content: 'Please check with your credentials');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        customSnackBar(
            context: context, content: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        customSnackBar(
            context: context,
            content: 'Wrong password provided for that user.');
      }
    }
  }

  void registerWithEmail(
    BuildContext context,
    String email,
    String password,
    String firstName,
    String lastName,
    String plastic,
    String metal,
    String glass,
    String kitchen,
    String paper,
  ) async {
    try {
      loadingDialogBox(context, 'Validating details');

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return organisation.doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': "$firstName $lastName",
        'email': email,
        'mobile': '',
        'address': '',
        'image': '',
        'price': {
          'Glass': glass,
          'Metal': metal,
          'Paper': paper,
          'Kitchen_waste': kitchen,
          'Plastic': plastic
        }
      }).then((value) async {
        await credential.user!.sendEmailVerification().then((value) {
          // Navigator.pushReplacementNamed(context, EmailVerifyScreen.screenId);
          Navigator.pushReplacementNamed(
              context, OrganisationLocation.screenId);
        });

        customSnackBar(context: context, content: 'Registered successfully');
      }).catchError((onError) {
        if (kDebugMode) {
          print(onError);
        }
        customSnackBar(
            context: context,
            content:
                'Failed to add user to database, please try again $onError');
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        customSnackBar(
            context: context, content: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        customSnackBar(
            context: context,
            content: 'The account already exists for that email.');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      customSnackBar(
          context: context, content: 'Error occured: ${e.toString()}');
    }
  }
}

loadingDialogBox(BuildContext context, String loadingMessage) {
  AlertDialog alert = AlertDialog(
    content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularProgressIndicator(
            color: secondaryColor,
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            loadingMessage,
            style: TextStyle(
              color: blackColor,
            ),
          )
        ]),
  );

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

customSnackBar({required BuildContext context, required String content}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: blackColor,
    content: Text(
      content,
      style: TextStyle(color: whiteColor, letterSpacing: 0.5),
    ),
  ));
}

wrongDetailsAlertBox(String text, BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Text(
      text,
      style: TextStyle(
        color: blackColor,
      ),
    ),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Ok',
          )),
    ],
  );

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
