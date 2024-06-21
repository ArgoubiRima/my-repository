import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled10/data/shared_data.dart';
import 'package:untitled10/global/notifications.dart';
import 'package:untitled10/model/person.dart';
import 'package:untitled10/service/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController identityCodeController = TextEditingController();
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

  handleLogin() async {
    if (loginController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        _image != null) {
      showError("One auth method is required, not both");
      return;
    } else {
      if (_image != null) {
        loginWithFingerprint();
      } else {
        _login();
      }
    }
  }

  Future<void> loginWithFingerprint() async {
    print("from finger ${identityCodeController.text}");
    if (identityCodeController.text.isEmpty) {
      showError("Please fill all the fields!");
      return;
    }

    if (_image == null) {
      showError("Image is null");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      FormData formData = FormData.fromMap({
        "fingerprintImage": await MultipartFile.fromFile(
          _image!.path,
          filename: "fingerprint.png", // You can set the filename as you like
        ),
      });

      Response response = await Api.makeRequest(
        requestType: RequestType.post,
        endpoint: "/auth/login_fingerprint",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      print(response);

      if (response.statusCode == 200) {
        SharedData.person = Person.fromJson(response.data["profile"]);
        SharedData.username = response.data['username'];
        if (identityCodeController.text == "0000") {
          Get.offAllNamed("/user-profile");
        } else {
          Get.offAllNamed("/person-list");
        }
      } else {
        showError(response.data['error']);
      }
    } catch (e) {
      setState(() {
        showError("Invalid credentials");
        isLoading = false;
      });
      print("Exception: $e");
    }
  }

  _login() async {
    print("from login ${identityCodeController.text}");

    if (loginController.text.isEmpty ||
        passwordController.text.isEmpty ||
        identityCodeController.text.isEmpty) {
      showError("Please fill all the fields!");
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    var data = {
      "username": loginController.text,
      "password": passwordController.text,
    };
    print(data);

    try {
      Response response = await Api.makeRequest(
        requestType: RequestType.post,
        endpoint: "/auth/login",
        data: data,
      );

      if (response.statusCode == 200) {
        SharedData.person = Person.fromJson(response.data["profile"]);
        SharedData.username = loginController.text;
        if (identityCodeController.text == "0000") {
          Get.offAllNamed("/user-profile");
        } else {
          Get.offAllNamed("/person-list");
        }
      } else if (response.statusCode != 200) {
        showError(response.data['error']);
        return;
      } else {
        showError("An error has occurred.");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.blue, // Fond bleu
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Carré blanc
                      borderRadius:
                          BorderRadius.circular(10.0), // Bordures arrondies
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'image/logo.jpeg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              'SecureTouch',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: loginController,
                          decoration: const InputDecoration(
                            labelText: 'Login :',
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password :',
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Or If you want to authenticate with your fingerprint',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: GestureDetector(
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
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: identityCodeController,
                          decoration: const InputDecoration(
                            labelText:
                                'Identity Code (Note: If you are a normal user, enter \'0000\' as the identity code)',
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: handleLogin,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
