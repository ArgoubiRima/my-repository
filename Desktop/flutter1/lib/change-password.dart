import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:untitled10/data/shared_data.dart';
import 'package:untitled10/global/notifications.dart';
import 'package:untitled10/service/api.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool isLoading = false;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswrodController =
      TextEditingController();

  _changePassword() async {
    if (passwordController.text.isEmpty ||
        confirmPasswrodController.text.isEmpty) {
      showError("Please fill all the fields!");
      return;
    }

    if (passwordController.text != confirmPasswrodController.text) {
      showError("Passwords Must match!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    var data = {
      "username": SharedData.username,
      "password": passwordController.text,
    };
    print(data);
    try {
      Response response = await Api.makeRequest(
        requestType: RequestType.post,
        endpoint: "/auth/change_pw",
        data: data,
      );
      print(response);

      if (response.statusCode == 200) {
        showSuccess("Password updated successfully");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.blue, // Fond bleu
              padding: const EdgeInsets.all(20.0),
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
                        const SizedBox(height: 20),
                        const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'New Password:',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: confirmPasswrodController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm New Password:',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _changePassword();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Change Password'),
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
