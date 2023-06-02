import 'package:flutter/material.dart';

import '../location_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const String screenId = 'onboarding_screen';

  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const LargeHeadingWidget(
                  heading: 'Choose your pricing',
                  subheadingTextSize: 16,
                  headingTextSize: 30,
                  subHeading:
                      'To continue, we need to know your sell/buy location so that we can further assist you'),
            ],
          ),
        ),
      ),
    );
  }
}
