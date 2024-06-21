import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:untitled10/data/shared_data.dart';
import 'package:untitled10/global/notifications.dart';
import 'package:untitled10/service/api.dart';

class PersonListPage extends StatefulWidget {
  const PersonListPage({Key? key}) : super(key: key);

  @override
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  bool isLoading = true;
  _getPersons() async {
    try {
      Response response = await Api.makeRequest(
        requestType: RequestType.get,
        endpoint: "/persons",
      );
      print(response);
      if (response.statusCode == 200) {
        persons = (response.data as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        print(persons.length);
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

  _deletePerson(id) async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Api.makeRequest(
        requestType: RequestType.delete,
        endpoint: "/persons/$id",
      );
      print(response);
      if (response.statusCode == 200) {
        _getPersons();
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

  List<Map<String, dynamic>> persons = []; // Liste de personnes avec rôles

  @override
  void initState() {
    _getPersons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des personnes'),
        actions: [
          TextButton(
              onPressed: () {
                Get.toNamed("/user-profile");
              },
              child: Text("My profile")),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.blue, // Fond bleu
              child: Center(
                child: SingleChildScrollView(
                  // Ajout d'un SingleChildScrollView pour gérer le débordement
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    color: Colors.white, // Carreau blanc
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          // Row avec le texte et l'image
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'SecureTouch',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              'image/logo.jpeg',
                              height: 100.0,
                              width: 100.0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Liste des personnes :', // Ajout du texte avant le DataTable
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.offAllNamed("/login");
                                SharedData.person = null;
                                SharedData.username = null;
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context,
                                    '/add-person'); // Navigation vers la page AddFormulaire
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Add a New User',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Last Name')),
                              DataColumn(label: Text('First Name')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Address')),
                              DataColumn(label: Text('Phone Number')),
                              DataColumn(label: Text('Date of Birth')),
                              DataColumn(label: Text('Gender')),
                              DataColumn(label: Text('Photo')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: persons.map((person) {
                              return DataRow(cells: [
                                DataCell(Text(person["id"]
                                    .toString())), // Remplacez par les données réelles

                                DataCell(Text(person[
                                    "lastname"])), // Remplacez par les données réelles

                                DataCell(Text(person[
                                    "firstname"])), // Remplacez par les données réelles

                                DataCell(Text(person[
                                    "email"])), // Remplacez par les données réelles

                                DataCell(Text(person[
                                    "address"])), // Remplacez par les données réelles

                                DataCell(Text(person["phoneNumber"]
                                    .toString())), // Remplacez par les données réelles

                                DataCell(Text(person[
                                    "dob"])), // Remplacez par les données réelles

                                DataCell(Text(person[
                                    "gender"])), // Remplacez par les données réelles

                                DataCell(Text(
                                    'Photo')), // Remplacez par les données réelles

                                DataCell(Row(
                                  // Row pour les boutons d'action
                                  children: [
                                    IconButton(
                                      // Bouton d'édition
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Get.toNamed(
                                          "/modify-person",
                                          arguments: person,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      // Bouton de suppression
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                            context, person['id']);
                                      },
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this person?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deletePerson(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
