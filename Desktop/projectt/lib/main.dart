// main.dart
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:untitled10/profil-user.dart';
import 'addformulaire.dart';
import 'change-password.dart';
import 'fingerprint.dart';
import 'login_page.dart';
import 'person_list_page.dart'; // Importez la nouvelle classe
import 'ModifyPerson.dart'; // Importez la classe ModifyPerson

void main() {
  runApp(GetMaterialApp(
    title: 'Mon App',
    debugShowCheckedModeBanner: false,
    initialRoute: '/login', // Définir la route initiale
    routes: {
      '/login': (context) => const LoginPage(), // Page de connexion
      '/person-list': (context) => const PersonListPage(), // Nouvelle page
      '/add-person': (context) =>
          const AddFormulaire(), // Nouvelle route pour AddFormulaire
      '/change-password': (context) =>
          const ChangePasswordPage(), // Nouvelle route pour ChangePasswordPage
      '/user-profile': (context) =>
          UserProfile(), // Nouvelle route pour ProfileUser
      '/modify-person': (context) => ModifyPerson(),
      '/image-upload': (context) =>
          ImageUploadPage(), // Nouvelle route pour ImagePage
    },
  ));
}
