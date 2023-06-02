import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../constant/validators.dart';
import '../service/organisation_auth.dart';
import 'login.dart';

class OrganisationRegister extends StatefulWidget {
  static const String screenId = 'organization_register';

  const OrganisationRegister({Key? key}) : super(key: key);

  @override
  _OrganisationRegisterState createState() => _OrganisationRegisterState();
}

class _OrganisationRegisterState extends State<OrganisationRegister> {
  OrganisationAuth authService = OrganisationAuth();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _plasticController;
  late final TextEditingController _metalController;
  late final TextEditingController _glassController;
  late final TextEditingController _paperController;
  late final TextEditingController _kitchenController;
  late final FocusNode _firstNameNode;
  late final FocusNode _lastNameNode;
  late final FocusNode _emailNode;
  late final FocusNode _passwordNode;
  late final FocusNode _confirmPasswordNode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _paperController = TextEditingController();
    _metalController = TextEditingController();
    _glassController = TextEditingController();
    _kitchenController = TextEditingController();
    _plasticController = TextEditingController();
    _firstNameNode = FocusNode();
    _lastNameNode = FocusNode();
    _emailNode = FocusNode();
    _passwordNode = FocusNode();
    _confirmPasswordNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _confirmPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('image/Register.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              const Text(
                'Welcome To Recysell',
                style: TextStyle(color: Colors.black, fontSize: 26),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(right: 35, left: 35),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _firstNameController,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'first name');
                            },
                            decoration: InputDecoration(
                                hintText: 'First Name',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _lastNameController,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'last name');
                            },
                            decoration: InputDecoration(
                                hintText: 'Last Name',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              return validateEmail(
                                  value,
                                  EmailValidator.validate(
                                      _emailController.text));
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: 'Email',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
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
                            height: 15,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            validator: (value) {
                              return validateSamePassword(
                                  value, _passwordController.text);
                            },
                            decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _plasticController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'plastic price');
                            },
                            decoration: InputDecoration(
                                hintText: 'Plastic per kg',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _metalController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'Metal price');
                            },
                            decoration: InputDecoration(
                                hintText: 'Metal per kg',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _glassController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'first name');
                            },
                            decoration: InputDecoration(
                                hintText: 'Glass per kg',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _kitchenController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'first name');
                            },
                            decoration: InputDecoration(
                                hintText: 'Kitchen waste per kg',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _paperController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return checkNullEmptyValidation(
                                  value, 'Paper price');
                            },
                            decoration: InputDecoration(
                                hintText: 'Paper per kg',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black38,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, OrganizationLogin.screenId);
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Container(
          width: size.width * 0.8,
          child: FloatingActionButton.extended(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await authService.getAdminCredentialEmailAndPassword(
                    context: context,
                    firstName: _firstNameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                    email: _emailController.text,
                    password: _passwordController.text,
                    paper: _paperController.text,
                    glass: _glassController.text,
                    plastic: _plasticController.text,
                    kitchen: _kitchenController.text,
                    metal: _metalController.text,
                    isLoginUser: false);
              }
            },
            label: const Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xFF89cc4f),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
