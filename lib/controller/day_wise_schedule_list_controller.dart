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
      }

      if (Get.arguments["selectedDay"].runtimeType == String) {
        selectedDay = Get.arguments["selectedDay"];
      }
    }
  }

  List<Appointment> getAppointmentsForTime(DateTime time) {
    return todayAppointments.where((appointment) {
      // Check if the appointment starts in the same hour of the day as the given time slot
      return appointment.startTime.year == time.year &&
          appointment.startTime.month == time.month &&
          appointment.startTime.day == time.day &&
          appointment.startTime.hour == time.hour;
    }).toList();
  }

}
