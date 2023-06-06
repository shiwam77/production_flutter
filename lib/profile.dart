import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:production_flutter/service/auth.dart';
import 'package:production_flutter/service/user_service.dart';
import 'package:production_flutter/utils.dart';

import 'color.dart';
import 'constant/validators.dart';
import 'home.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String _selectedImagePath = '';
  late Future initUserDetail;
  Map<String, dynamic>? userData = {};
  Auth authService = Auth();
  UserService firebaseUser = UserService();
  bool imageUploading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initUserDetail = firebaseUser.getUserData();
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
                            SizedBox(height: 50),
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
                                          firebaseUser.updateFirebaseUser(
                                              context, {
                                            'image': url,
                                            'name':
                                                "${_firstNameController.text} ${_lastNameController.text}"
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
                      SizedBox(height: 50),
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

                                uploadFile(context, _selectedImagePath)
                                    .then((url) {
                                  if (url != null) {
                                    setState(() {
                                      imageUploading = false;
                                      _selectedImagePath = '';
                                    });
                                    firebaseUser.updateFirebaseUser(context, {
                                      'image': url,
                                      'name':
                                          "${_firstNameController.text} ${_lastNameController.text}"
                                    }).then((value) {
                                      Navigator.pop(context);
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          MyHome.screenId, (route) => false);
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, MyHome.screenId);
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
                  )
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: _selectImage,
                //       child: Container(
                //         width: 100,
                //         height: 100,
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           border: Border.all(
                //             color: Colors.grey,
                //             width: 1.0,
                //           ),
                //           image: _selectedImagePath.isNotEmpty
                //               ? DecorationImage(
                //                   image: FileImage(
                //                     File(_selectedImagePath),
                //                   ),
                //                   fit: BoxFit.cover,
                //                 )
                //               : null,
                //         ),
                //         child: _selectedImagePath.isEmpty
                //             ? Icon(Icons.add_a_photo)
                //             : null,
                //       ),
                //     ),
                //     SizedBox(height: 30),
                //     TextFormField(
                //       controller: _firstNameController,
                //       decoration: InputDecoration(
                //         labelText: 'First Name',
                //         border: OutlineInputBorder(),
                //       ),
                //     ),
                //     SizedBox(height: 10),
                //     TextFormField(
                //       controller: _lastNameController,
                //       decoration: InputDecoration(
                //         labelText: 'Last Name',
                //         border: OutlineInputBorder(),
                //       ),
                //     ),
                //     SizedBox(height: 50),
                //     Container(
                //       width: size.width * 0.8,
                //       child: ElevatedButton(
                //         style: ButtonStyle(
                //           shape: MaterialStateProperty.all(
                //             RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(20),
                //             ),
                //           ),
                //           padding: MaterialStateProperty.all(
                //             const EdgeInsets.symmetric(
                //                 vertical: 15, horizontal: 15),
                //           ),
                //           backgroundColor:
                //               MaterialStateProperty.all(Color(0xFF89cc4f)),
                //         ),
                //         onPressed: () {
                //           String name = _firstNameController.text;
                //           String email = _lastNameController.text;
                //           String password = _passwordController.text;
                //           String location = _locationController.text;
                //           uploadFile(context, _selectedImagePath).then((url) {
                //             if (url != null) {}
                //           });
                //           // Perform the necessary actions with the entered data
                //
                //           Navigator.pop(context);
                //         },
                //         child: Text(
                //           'Save',
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 18,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
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
