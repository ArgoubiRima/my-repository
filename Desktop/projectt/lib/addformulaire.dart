import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled10/global/notifications.dart';
import 'package:untitled10/service/api.dart';

class AddFormulaire extends StatefulWidget {
  const AddFormulaire({Key? key}) : super(key: key);

  @override
  _AddFormulaireState createState() => _AddFormulaireState();
}

class _AddFormulaireState extends State<AddFormulaire> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String _selectedGender = "";
  String _selectedRole = "";

  File? _image;

  bool isLoading = false;

  Future<void> getImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  bool _validateFields() {
    String namePattern = r'^[a-zA-Z]+$';
    String phonePattern = r'^[0-9]+$';
    String datePattern = r'^\d{2}/\d{2}/\d{4}$'; // Date format: dd/MM/yyyy

    String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; // Email regex pattern

    RegExp nameRegExp = RegExp(namePattern);
    RegExp phoneRegExp = RegExp(phonePattern);
    RegExp dateRegExp = RegExp(datePattern);
    RegExp emailRegExp = RegExp(emailPattern);

    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _birthdayController.text.isEmpty ||
        _selectedGender.isEmpty) {
      showError("All fields are necessary");
      return false;
    }

    if (!nameRegExp.hasMatch(_lastNameController.text)) {
      showError("Last name should contain only alphabetic characters");
      return false;
    }
    if (!nameRegExp.hasMatch(_firstNameController.text)) {
      showError("First name should contain only alphabetic characters");
      return false;
    }
    if (!emailRegExp.hasMatch(_emailController.text)) {
      showError("Email is not valid");
      return false;
    }

    if (!phoneRegExp.hasMatch(_phoneNumberController.text)) {
      showError("Phone number should contain only numeric characters");
      return false;
    }

    if (!dateRegExp.hasMatch(_birthdayController.text)) {
      showError("Birthday should be in the format YYYY-MM-DD");
      return false;
    }

    // Additional check for valid date (optional)
    try {
      List<String> dateParts = _birthdayController.text.split('/');
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      DateTime birthday = DateTime(year, month, day);
      if (birthday.year != year ||
          birthday.month != month ||
          birthday.day != day) {
        throw FormatException("Invalid date");
      }
    } catch (e) {
      showError("Birthday is not a valid date");
      return false;
    }

    return true;
  }

  _addUser() async {
    if (!_validateFields()) {
      return;
    }

    if (_image == null) {
      showError("Image is required");
      return;
    }
    setState(() {
      isLoading = true;
    });

    var data = {
      "profile": {
        "firstname": _firstNameController.text,
        "lastname": _lastNameController.text,
        "email": _emailController.text,
        "address": _addressController.text,
        "phoneNumber": _phoneNumberController.text,
        "dob": _birthdayController.text,
        "password": _passwordController.text,
        "confirm_password": _confirmPasswordController.text,
        "role": _selectedRole,
        "gender": _selectedGender,
      },
      "password": _passwordController.text,
    };

    try {
      Response response = await Api.makeRequest(
        requestType: RequestType.post,
        endpoint: "/persons",
        data: data,
      );
      print(response);
      print(response.statusCode);
      if (response.statusCode == 200) {
        await uploadFingerprint(response.data["id"].toString());
      } else if (response.statusCode != 200) {
        showError(response.data['error']);
        return;
      }
    } catch (e) {
      e.printError();
      showError("An error has occurred.");
      return;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> uploadFingerprint(String idPerson) async {
    try {
      FormData formData = FormData.fromMap({
        "fingerprintImage": await MultipartFile.fromFile(
          _image!.path,
          filename: "fingerprint.png", // You can set the filename as you like
        ),
      });

      Response response = await Api.makeRequest(
        requestType: RequestType.post,
        endpoint: "/persons/$idPerson/fingerprint",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      print(response);

      if (response.statusCode == 200) {
        Get.offAllNamed("/person-list");
      } else {
        showError("Error uploading image");
      }
    } catch (e) {
      showError("Fingerprint already exists, user not added");
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New User'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                color: Colors.blue, // Couleur de fond bleue
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Carreau blanc
                    borderRadius:
                        BorderRadius.circular(10.0), // Bordures arrondies
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20.0),
                          const Text(
                            'Register New User',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@gmail.com')) {
                                return 'Please enter a valid email address ending with @gmail.com';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _addressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _phoneNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _birthdayController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your date of birth';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Date of Birth',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          DropdownButtonFormField<String>(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your gender';
                              }
                              return null;
                            },
                            items:
                                <String>['Male', 'Female'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (_) {
                              _selectedGender = _!;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: getImage,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                              ),
                              child: _image != null
                                  ? Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 100,
                                      color: Colors.blue,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: _addUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.blue, // Couleur du bouton bleu
                            ),
                            child: const Text('Register'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
