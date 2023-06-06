import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:production_flutter/utils.dart';

import '../../color.dart';
import '../../constant/validators.dart';
import '../service/organisation_auth.dart';
import 'home.dart';

class OrganisationProfilePage extends StatefulWidget {
  @override
  _OrganisationProfilePageState createState() =>
      _OrganisationProfilePageState();
}

class _OrganisationProfilePageState extends State<OrganisationProfilePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _plasticController = TextEditingController();
  TextEditingController _metalController = TextEditingController();
  TextEditingController _glassController = TextEditingController();
  TextEditingController _paperController = TextEditingController();
  TextEditingController _kitchenController = TextEditingController();

  String _selectedImagePath = '';
  late Future initUserDetail;
  OrganisationAuth authService = OrganisationAuth();
  bool imageUploading = false;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? userData;
  @override
  void initState() {
    initUserDetail = authService.getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageUploading = true;
        _selectedImagePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (userData == null)
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
                        userData = data;
                        List<String> name =
                            data['name'].toString().split(' ').toList();
                        print(name.toList());
                        _firstNameController.text = name[0];
                        _lastNameController.text = name[1];
                        _metalController.text = data['price']['Metal'];
                        _plasticController.text = data['price']['Plastic'];
                        _paperController.text = data['price']['Paper'];
                        _kitchenController.text =
                            data['price']['Kitchen_waste'];
                        _glassController.text = data['price']['Glass'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _selectImage,
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    image: imageUploading == true &&
                                            _selectedImagePath.isNotEmpty
                                        ? DecorationImage(
                                            image: FileImage(
                                              File(_selectedImagePath),
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : data['image'].toString().isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    data['image'].toString()))
                                            : null,
                                  ),
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, right: 4),
                                    child: Icon(Icons.add_a_photo),
                                  )),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: _firstNameController,
                              validator: (value) {
                                return checkNullEmptyValidation(
                                    value, 'first name');
                              },
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _lastNameController,
                              validator: (value) {
                                return checkNullEmptyValidation(
                                    value, 'last name');
                              },
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _metalController,
                              validator: (value) {
                                return checkNullEmptyValidation(
                                    value, 'Metal price');
                              },
                              decoration: InputDecoration(
                                labelText: 'Metal price per kg',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _paperController,
                              validator: (value) {
                                return checkNullEmptyValidation(
                                    value, 'Paper price');
                              },
                              decoration: InputDecoration(
                                labelText: 'Paper price per kg',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _plasticController,
                              validator: (value) {
                                return checkNullEmptyValidation(
                                    value, 'Plastic price');
                              },
                              decoration: InputDecoration(
                                labelText: 'Plastic price per kg',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _glassController,
                              validator: (value) {
                                return checkNullEmptyValidation(
                                    value, 'Glass Price');
                              },
                              decoration: InputDecoration(
                                labelText: 'Glass price per kg',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _kitchenController,
                              validator: (value) {
                                return checkNullEmptyValidation(
                                    value, 'Kitchen Waste Price');
                              },
                              decoration: InputDecoration(
                                labelText: 'Kitchen Waste price per kg',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: size.width * 0.8,
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
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF89cc4f)),
                                ),
                                onPressed: () async {
                                  try {
                                    if (_formKey.currentState!.validate()) {
                                      loadingDialogBox(
                                          context, 'Updating user details');

                                      uploadFile(context, _selectedImagePath)
                                          .then((url) {
                                        if (url != null) {
                                          setState(() {
                                            imageUploading = false;
                                            _selectedImagePath = '';
                                          });
                                          authService
                                              .updateFirebaseUser(context, {
                                            'image': url,
                                            'name':
                                                "${_firstNameController.text} ${_lastNameController.text}",
                                            'price': {
                                              'Glass': _glassController.text,
                                              'Metal': _metalController.text,
                                              'Paper': _paperController.text,
                                              'Kitchen_waste':
                                                  _kitchenController.text,
                                              'Plastic': _plasticController.text
                                            }
                                          }).then((value) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        }
                                      });
                                    }
                                  } catch (e) {
                                    Navigator.pop(context);
                                    customSnackBar(
                                        context: context,
                                        content: 'Something went wrong');
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
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
                if (userData != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _selectImage,
                        child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              image: imageUploading == true &&
                                      _selectedImagePath.isNotEmpty
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(_selectedImagePath),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : userData!['image'].toString().isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              userData!['image'].toString()))
                                      : null,
                            ),
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, right: 4),
                              child: Icon(Icons.add_a_photo),
                            )),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _firstNameController,
                        validator: (value) {
                          return checkNullEmptyValidation(value, 'first name');
                        },
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _lastNameController,
                        validator: (value) {
                          return checkNullEmptyValidation(value, 'last name');
                        },
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _metalController,
                        validator: (value) {
                          return checkNullEmptyValidation(value, 'Metal price');
                        },
                        decoration: InputDecoration(
                          labelText: 'Metal price per kg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _paperController,
                        validator: (value) {
                          return checkNullEmptyValidation(value, 'Paper price');
                        },
                        decoration: InputDecoration(
                          labelText: 'Paper price per kg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _plasticController,
                        validator: (value) {
                          return checkNullEmptyValidation(
                              value, 'Plastic price');
                        },
                        decoration: InputDecoration(
                          labelText: 'Plastic price per kg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _glassController,
                        validator: (value) {
                          return checkNullEmptyValidation(value, 'Glass Price');
                        },
                        decoration: InputDecoration(
                          labelText: 'Glass price per kg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _kitchenController,
                        validator: (value) {
                          return checkNullEmptyValidation(
                              value, 'Kitchen Waste Price');
                        },
                        decoration: InputDecoration(
                          labelText: 'Kitchen Waste price per kg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: size.width * 0.8,
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
                            try {
                              if (_formKey.currentState!.validate()) {
                                loadingDialogBox(
                                    context, 'Updating user details');
                                if (_selectedImagePath.isNotEmpty) {
                                  uploadFile(context, _selectedImagePath)
                                      .then((url) {
                                    if (url != null) {
                                      setState(() {
                                        imageUploading = false;
                                        _selectedImagePath = '';
                                      });
                                      authService.updateFirebaseUser(context, {
                                        'image': url,
                                        'name':
                                            "${_firstNameController.text} ${_lastNameController.text}",
                                        'price': {
                                          'Glass': _glassController.text,
                                          'Metal': _metalController.text,
                                          'Paper': _paperController.text,
                                          'Kitchen_waste':
                                              _kitchenController.text,
                                          'Plastic': _plasticController.text
                                        }
                                      }).then((value) {
                                        Navigator.pop(context);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                OrganisationHome.screenId,
                                                (route) => false);
                                      });
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, OrganisationHome.screenId);
                                    }
                                  });
                                } else {
                                  authService.updateFirebaseUser(context, {
                                    'name':
                                        "${_firstNameController.text} ${_lastNameController.text}",
                                    'price': {
                                      'Glass': _glassController.text,
                                      'Metal': _metalController.text,
                                      'Paper': _paperController.text,
                                      'Kitchen_waste': _kitchenController.text,
                                      'Plastic': _plasticController.text
                                    }
                                  }).then((value) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                }
                              }
                            } catch (e) {
                              Navigator.pop(context);
                              customSnackBar(
                                  context: context,
                                  content: 'Something went wrong');
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class locationTextWidget extends StatelessWidget {
  final String? location;
  const locationTextWidget({Key? key, required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.pin_drop,
          size: 18,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          location ?? '',
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
