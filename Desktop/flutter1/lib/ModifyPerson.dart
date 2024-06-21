import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:untitled10/data/shared_data.dart';
import 'package:untitled10/global/notifications.dart';
import 'package:untitled10/model/person.dart';
import 'package:untitled10/service/api.dart';

class ModifyPerson extends StatefulWidget {
  const ModifyPerson({Key? key}) : super(key: key);

  @override
  _ModifyPersonState createState() => _ModifyPersonState();
}

class _ModifyPersonState extends State<ModifyPerson> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String _selectedGender = "";
  bool isLoading = false;

  var person;

  // Future<void> getImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       _isImageSelected = true;
  //     } else {
  //       _isImageSelected = false;
  //       print('No image selected.');
  //     }
  //   });
  // }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _modifyUser();
    }
  }

  void _cancel() {
    Navigator.of(context).pop(); // Retourne à la page précédente
  }

  @override
  void initState() {
    person = Get.arguments;
    Person p = SharedData.person!;
    _lastNameController.text = p.lastname!;
    _firstNameController.text = p.firstname!;
    _emailController.text = p.email!;
    _addressController.text = p.address!;
    _phoneNumberController.text = p.phoneNumber!;
    _birthdayController.text = p.dob!;
    // _selectedGender = p.gender!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Person'),
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
                            'Modify Person',
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

                          const SizedBox(height: 20.0),
                          // GestureDetector(
                          //   onTap: getImage,
                          //   child: Container(
                          //     width: 200,
                          //     height: 200,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: Colors.blue),
                          //     ),
                          //     child: _image != null
                          //         ? Image.file(
                          //             _image!,
                          //             fit: BoxFit.cover,
                          //           )
                          //         : const Icon(
                          //             Icons.add_photo_alternate_outlined,
                          //             size: 100,
                          //             color: Colors.blue,
                          //           ),
                          //   ),
                          // ),
                          // const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text('Modify'),
                              ),
                              ElevatedButton(
                                onPressed: _cancel,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                child: const Text('Cancel'),
                              ),
                            ],
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

  void _modifyUser() async {
    setState(() {
      isLoading = true;
    });

    var data = {
      "id": person["id"],
      "firstname": _firstNameController.text,
      "lastname": _lastNameController.text,
      "email": _emailController.text,
      "address": _addressController.text,
      "phoneNumber": _phoneNumberController.text,
      "dob": _birthdayController.text,
      "gender": _selectedGender,
    };

    print(data);

    try {
      Response response = await Api.makeRequest(
        requestType: RequestType.put,
        endpoint: "/persons/${person["id"]}",
        data: data,
      );
      print(response);
      if (response.statusCode == 200) {
        Person newPerson = Person.fromJson(response.data);
        SharedData.person = newPerson;
        Get.offAllNamed("/person-list");
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
}
