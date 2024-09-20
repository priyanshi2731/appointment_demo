import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../appointment_calender.dart';

class DayWiseScheduleListController extends GetxController {
  List<Appointment> todayAppointments = [];
  String selectedDay = "";

  List<DateTime> allHoursInDay = [];
  final ScrollController scrollController = ScrollController();
  bool showScrollToTopButton = false;
  bool activeSendButton = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments["appointments"].runtimeType == List<Appointment>) {
        todayAppointments = Get.arguments["appointments"];
        todayAppointments.sort((a, b) => a.startTime.compareTo(b.startTime)); // Sort appointments by start time
      }

      if (Get.arguments["selectedDay"].runtimeType == String) {
        selectedDay = Get.arguments["selectedDay"];
      }
    }
  }
}
