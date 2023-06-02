import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constant/validators.dart';
import '../service/organisation_auth.dart';

class OrganizationLogin extends StatefulWidget {
  static const String screenId = 'organization_login';

  const OrganizationLogin({Key? key}) : super(key: key);

  @override
  _OrganizationLoginState createState() => _OrganizationLoginState();
}

class _OrganizationLoginState extends State<OrganizationLogin> {
  OrganisationAuth authService = OrganisationAuth();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailNode;
  late final FocusNode _passwordNode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailNode = FocusNode();
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('image/Login.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 80, top: 130),
              child: const Text(
                'Welcome To Recysell',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    right: 35,
                    left: 35),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: _emailNode,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return validateEmail(value,
                              EmailValidator.validate(_emailController.text));
                        },
                        decoration: InputDecoration(
                            hintText: 'Email',
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        focusNode: _passwordNode,
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          return validatePassword(
                              value, _passwordController.text);
                        },
                        decoration: InputDecoration(
                            hintText: 'Password',
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Text('Forget Password?',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey[500])),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        width: size.width * 0.8,
                        child: ClipRRect(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF89cc4f)),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await authService
                                    .getAdminCredentialEmailAndPassword(
                                        context: context,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        isLoginUser: true);
                              }
                            },
                            child: const Text("LOGIN",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Don\'t have an account?",
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 20),
                              children: [
                            TextSpan(
                              text: " Create",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, 'organization_register');
                                },
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
