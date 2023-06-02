import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:production_flutter/organisation/onboarding_screen.dart';

import 'auth/login.dart';
import 'auth/sign_up.dart';
import 'home/home.dart';
import 'location.dart';
import 'organisation_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        'organization_login': (context) => const OrganizationLogin(),
        'organization_register': (context) => const OrganisationRegister(),
        'organisation_home': (context) => const OrganisationHome(),
        'organisation_location': (context) => const OrganisationLocation(),
        '/': (context) => const OrganisationSplash(),
        'onboarding_screen': (context) => const OnboardingScreen(),
      },
    );
  }
}
