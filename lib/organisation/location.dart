import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:production_flutter/login.dart';
import 'package:production_flutter/organisation/service/organisation_auth.dart';
import 'package:production_flutter/utils.dart';

import '../color.dart';
import 'home/home.dart';

class OrganisationLocation extends StatefulWidget {
  final bool? onlyPop;
  final String? popToScreen;
  static const String screenId = 'organisation_location';
  const OrganisationLocation({
    this.popToScreen,
    this.onlyPop,
    Key? key,
  }) : super(key: key);

  @override
  State<OrganisationLocation> createState() => _OrganisationLocationState();
}

class _OrganisationLocationState extends State<OrganisationLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _body(context),
        bottomNavigationBar: BottomLocationPermissionWidget(
            onlyPop: widget.onlyPop, popToScreen: widget.popToScreen ?? ''));
  }

  Widget _body(context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      OrganisationHome.screenId, (route) => false);
                },
                child: Text("Skip"),
              ),
            ),
          ),
          const LargeHeadingWidget(
              heading: 'Choose Location',
              subheadingTextSize: 16,
              headingTextSize: 30,
              subHeading:
                  'To continue, we need to know your sell/buy location so that we can further assist you'),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 300,
            width: 300,
            child: Lottie.asset(
              'image/lottie/location_lottie.json',
            ),
          ),
        ],
      ),
    );
  }
}

class BottomLocationPermissionWidget extends StatefulWidget {
  final bool? onlyPop;
  final String popToScreen;
  const BottomLocationPermissionWidget({
    required this.popToScreen,
    this.onlyPop,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomLocationPermissionWidget> createState() =>
      _BottomLocationPermissionWidgetState();
}

class _BottomLocationPermissionWidgetState
    extends State<BottomLocationPermissionWidget> {
  OrganisationAuth firebaseUser = OrganisationAuth();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: roundedButton(
          context: context,
          text: 'Choose Location',
          bgColor: secondaryColor,
          onPressed: () {
            openLocationBottomsheet(context);
          }),
    );
  }

  openLocationBottomsheet(BuildContext context) {
    String countryValue = '';
    String stateValue = '';
    String cityValue = '';
    String address = '';
    String manualAddress = '';
    loadingDialogBox(context, 'Fetching details..');
    getLocationAndAddress(context).then((location) {
      if (location != null) {
        Navigator.pop(context);
        setState(() {
          address = location;
        });
        showModalBottomSheet(
            isScrollControlled: true,
            enableDrag: true,
            context: context,
            builder: (context) {
              return Container(
                color: whiteColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(
                        color: blackColor,
                      ),
                      elevation: 1,
                      backgroundColor: whiteColor,
                      title: Row(children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.clear,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Select Location',
                          style: TextStyle(color: blackColor),
                        )
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.search),
                            hintText: 'Select city, area or neighbourhood',
                            hintStyle: TextStyle(
                              color: greyColor,
                              fontSize: 12,
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        loadingDialogBox(context, 'Updating location..');
                        await getCurrentLocation(
                                context, serviceEnabled, permission)
                            .then((value) {
                          if (value != null) {
                            String addressOne = address.split(',').first;
                            firebaseUser.updateFirebaseUser(context, {
                              'location':
                                  GeoPoint(value.latitude, value.longitude),
                              'address': address,
                              'addressOne': addressOne
                            }).then((value) {
                              return (widget.onlyPop == true)
                                  ? (widget.popToScreen.isNotEmpty)
                                      ? Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              widget.popToScreen,
                                              (route) => false)
                                      : Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              OrganisationHome.screenId,
                                              (route) => false)
                                  : Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          OrganisationHome.screenId,
                                          (route) => false);
                            });
                          }
                        });
                      },
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.my_location,
                        color: secondaryColor,
                      ),
                      title: Text(
                        'Use current Location',
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        address == '' ? 'Fetch current Location' : address,
                        style: TextStyle(
                          color: greyColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      } else {
        Navigator.pop(context);
      }
    });
  }
}

class LargeHeadingWidget extends StatefulWidget {
  final String heading;
  final double? headingTextSize;
  final Color? headingTextColor;
  final String subHeading;
  final double? subheadingTextSize;
  final Color? subheadingTextColor;
  final String? anotherTaglineText;
  final Color? anotherTaglineColor;
  final bool? taglineNavigation;

  const LargeHeadingWidget(
      {Key? key,
      required this.heading,
      required this.subHeading,
      this.subheadingTextSize,
      this.headingTextSize,
      this.subheadingTextColor,
      this.headingTextColor,
      this.anotherTaglineText,
      this.anotherTaglineColor,
      this.taglineNavigation})
      : super(key: key);

  @override
  State<LargeHeadingWidget> createState() => _LargeHeadingWidgetState();
}

class _LargeHeadingWidgetState extends State<LargeHeadingWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                widget.heading,
                style: TextStyle(
                    color: widget.headingTextColor ?? blackColor,
                    fontSize: widget.headingTextSize ?? 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: RichText(
                text: TextSpan(
                    text: widget.subHeading,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      color: widget.subheadingTextColor ?? greyColor,
                      fontSize: widget.subheadingTextSize ?? 25,
                    ),
                    children: [
                      widget.anotherTaglineText != null
                          ? TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.taglineNavigation != null
                                    ? () {
                                        Navigator.pushReplacementNamed(
                                            context, MyLogin.screenId);
                                      }
                                    : () {},
                              text: widget.anotherTaglineText,
                              style: TextStyle(
                                color: widget.anotherTaglineColor ?? greyColor,
                                fontSize: widget.subheadingTextSize ?? 25,
                              ),
                            )
                          : const TextSpan(),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget roundedButton({
  context,
  required Color? bgColor,
  required Function()? onPressed,
  Color? textColor,
  double? width,
  double? heightPadding,
  required String? text,
  Color? borderColor,
}) {
  return SizedBox(
    width: width ?? double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(
                color: borderColor ?? secondaryColor,
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(bgColor)),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: heightPadding ?? 15),
        child: Text(
          text!,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    ),
  );
}
