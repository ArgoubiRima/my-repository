import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

showError(String content) {
  if (!Get.isSnackbarOpen) {
    Get.snackbar("Error", content,
        colorText: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: Colors.red.withOpacity(0.8),
        icon: const Icon(
          LineIcons.exclamationCircle,
          color: Colors.white,
          size: 30,
        ));
  }
}

showSuccess(String content) {
  if (!Get.isSnackbarOpen) {
    Get.snackbar(
      "Success",
      content,
      colorText: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      backgroundColor: Colors.teal.withOpacity(0.8),
      icon: const Icon(
        LineIcons.checkCircle,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
