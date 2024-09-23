// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:appointment_demo/utils/common_images.dart';
import 'package:appointment_demo/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'app_animated_cliprect.dart';
import 'day_wise_schedule_list.dart';

class CalendarWithAppointmentsPage extends StatefulWidget {
  const CalendarWithAppointmentsPage({super.key});

  @override
  _CalendarWithAppointmentsPageState createState() => _CalendarWithAppointmentsPageState();
}

class _CalendarWithAppointmentsPageState extends State<CalendarWithAppointmentsPage> {
  DateTime _focusedDay = DateTime.parse("2024-09-02 00:00:00.000Z");
  DateTime _selectedDay = DateTime.parse("2024-09-02 00:00:00.000Z");
  final List<Appointment> _appointments = getCalendarData();
  final List<DateTime> _allDaysInMonth = [];
  bool _showCalendar = true;

  final ScrollController _scrollController = ScrollController();
  bool showScrollToTopButton = false;
  bool activeSendButton = false;

  @override
  void initState() {
    super.initState();
    _populateAllDaysOfMonth();
  }

  void _populateAllDaysOfMonth() {
    DateTime now = _focusedDay;
    int totalDays = DateTime(now.year, now.month + 1, 0).day;

    _allDaysInMonth.clear();
    for (int i = 1; i <= totalDays; i++) {
      _allDaysInMonth.add(DateTime(now.year, now.month, i));
    }
    setState(() {});
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _appointments.where((appointment) => appointment.startTime.year == day.year && appointment.startTime.month == day.month && appointment.startTime.day == day.day).toList();
  }

  void _scrollToFirstDay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Center(
          child: SvgPicture.asset(
            CommonImages.menu,
            height: 24.h,
            width: 24.w,
            fit: BoxFit.contain,
            // width: Get.width,
          ),
        ),
        leadingWidth: 56.w,
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            setState(() {
              _showCalendar = !_showCalendar; // Toggle calendar visibility
            });
          },
          child: Row(
            children: [
              UiUtils.fadeSwitcherWidget(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  DateFormat('MMMM').format(_focusedDay),
                  key: ValueKey<int>(_focusedDay.hashCode),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ).paddingOnly(right: 5.w),
              ),
              _showCalendar == true
                  ? SvgPicture.asset(
                      CommonImages.arrowUp,
                      height: 16.h,
                      width: 16.w,
                      fit: BoxFit.contain,
                      // width: Get.width,
                    )
                  : SvgPicture.asset(
                      CommonImages.arrowDown,
                      height: 16.h,
                      width: 16.w,
                      fit: BoxFit.contain,
                      // width: Get.width,
                    ),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          SvgPicture.asset(
            CommonImages.notification,
            height: 24.h,
            width: 24.w,
            fit: BoxFit.contain,
            // width: Get.width,
          ).paddingOnly(right: 20.w),
        ],
      ),
      body: Column(
        // alignment: Alignment.topCenter,
        children: [
          /// Date picker
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0d000000),
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                  blurRadius: 30,
                ),
              ],
            ),
            child: AnimatedClipRect(
              open: _showCalendar,
              child: SizedBox(
                height: 290,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: TableCalendar(
                    rowHeight: 40,
                    daysOfWeekHeight: 40,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,
                    weekendDays: const [DateTime.sunday],
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      // Check if the selected day is a weekend (Sunday)
                      if (selectedDay.weekday == DateTime.sunday) {
                        // Do nothing if it's a weekend
                        UiUtils.toast("It's Weekend.");
                        print("weekend");
                        print("It's Weekend, ${UiUtils.getRandomString(1)}");
                      } else if (selectedDay != focusedDay) {
                        // If selected day is outside the current month, prevent selection
                        print("Selected day is not in the current month.");

                        _focusedDay = selectedDay;

                        _selectedDay = selectedDay;
                      } else {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _populateAllDaysOfMonth();
                        print("Working");
                      }

                      setState(() {});
                      // print("$focusedDay");
                      print("$selectedDay");
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                        _populateAllDaysOfMonth();
                      });
                    },
                    calendarStyle: CalendarStyle(
                      cellMargin: const EdgeInsets.all(5),
                      todayDecoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF4E00)),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xFFFF4E00),
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      todayTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      outsideTextStyle: TextStyle(
                        color: const Color(0xFFCACACA),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      disabledTextStyle: TextStyle(
                        color: const Color(0xFFCACACA),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      weekendTextStyle: TextStyle(
                        color: const Color(0xFFCACACA),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      markersAlignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                /// Schedule List
                NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification) {
                      // printOkStatus('ScrollStart');
                    } else if (scrollNotification is ScrollUpdateNotification) {
                      // printOkStatus('ScrollUpdate');
                    } else if (scrollNotification is ScrollEndNotification) {
                      // printOkStatus('ScrollEnd');
                    }

                    if (scrollNotification is ScrollUpdateNotification) {
                      if (scrollNotification.scrollDelta! > 0) {
                        // printYellow('Scrolling Down');
                      } else if (scrollNotification.scrollDelta! < 0) {
                        // printWhite('Scrolling Up');
                      }
                    }

                    /// Change top scroll button visibility
                    if (_scrollController.offset >= 500) {
                      if (!showScrollToTopButton) {
                        showScrollToTopButton = true;
                      }
                    } else {
                      if (showScrollToTopButton) {
                        showScrollToTopButton = false;
                      }
                    }

                    setState(() {});

                    return true;
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _allDaysInMonth.length,
                    separatorBuilder: (context, index) => Divider(height: 0, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      DateTime day = _allDaysInMonth[index];
                      List<Appointment> appointmentsForDay = _getAppointmentsForDay(day);

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Date header
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Combine both the date and day into a single string
                                String formattedDate = "${DateFormat('d').format(day)}, ${DateFormat('EEEE').format(day)}";

                                debugPrint("====$appointmentsForDay ====$_selectedDay===");
                                Get.to(
                                  () => const DayWiseScheduleList(),
                                  arguments: {
                                    "appointments": appointmentsForDay,
                                    "selectedDay": formattedDate,
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: appointmentsForDay.isEmpty
                                      ? Border(
                                          right: BorderSide(color: Colors.grey.shade200),
                                        )
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AnimatedDefaultTextStyle(
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isSameDay(_selectedDay, day) ? const Color(0xFFFF4E00) : Colors.black,
                                      ),
                                      duration: const Duration(milliseconds: 250),
                                      child: Text(
                                        DateFormat('d').format(day),
                                        // textAlign: TextAlign.center,
                                      ),
                                    ),
                                    AnimatedDefaultTextStyle(
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: isSameDay(_selectedDay, day) ? const Color(0xFFFF4E00) : const Color(0xFF667085),
                                      ),
                                      duration: const Duration(milliseconds: 250),
                                      child: Text(
                                        DateFormat('EEE').format(day),
                                        // textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// Appointment List
                          Expanded(
                            flex: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                border: appointmentsForDay.isNotEmpty
                                    ? Border(
                                        left: BorderSide(color: Colors.grey.shade200),
                                      )
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: appointmentsForDay.isNotEmpty
                                  ? ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(10),
                                      itemCount: appointmentsForDay.length,
                                      separatorBuilder: (BuildContext context, int index) {
                                        return const SizedBox(height: 15);
                                      },
                                      itemBuilder: (BuildContext context, int index) {
                                        return Container(
                                          margin: const EdgeInsets.only(left: 3),
                                          decoration: BoxDecoration(
                                            border: appointmentsForDay.isNotEmpty
                                                ? Border(
                                                    left: BorderSide(
                                                      color: _getAppointmentStatusIcon(appointmentsForDay[index].status)["color"],
                                                      width: 2.3,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                            // tileColor: Colors.grey,
                                            // leading: Icon(
                                            //   _getAppointmentStatusIcon(appointmentsForDay[index].status)["icon"],
                                            //   color: _getAppointmentStatusIcon(appointmentsForDay[index].status)["color"],
                                            // ),
                                            title: Text(
                                              appointmentsForDay[index].subject,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  appointmentsForDay[index].branch,
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ).paddingOnly(bottom: 8),
                                                Text.rich(
                                                  TextSpan(
                                                      text: appointmentsForDay[index].status,
                                                      style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontWeight: FontWeight.w500,
                                                        color: _getAppointmentStatusIcon(appointmentsForDay[index].status)["color"],
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: '  ●  ',
                                                          style: TextStyle(
                                                            color: const Color(0xFFD4D4D4),
                                                            fontSize: 8.sp,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: '${DateFormat.jm().format(appointmentsForDay[index].startTime)} - ${DateFormat.jm().format(appointmentsForDay[index].endTime)}',
                                                          style: TextStyle(
                                                            color: const Color(0xFF667085),
                                                            fontSize: 11.sp,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                /// Scroll manage button
                Positioned(
                  right: 20 + 4,
                  bottom: 20,
                  child: AnimatedOpacity(
                    opacity: showScrollToTopButton ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: () {
                        _scrollToFirstDay();
                      },
                      child: Container(
                          height: 33.w,
                          width: 33.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFFF4E00)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          foregroundDecoration: BoxDecoration(
                            color: const Color(0xFFFF4E00).withOpacity(0.03),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              CommonImages.blackArrow,
                              fit: BoxFit.contain,
                              // width: Get.width,
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get icon based on appointment status
  Map<String, dynamic> _getAppointmentStatusIcon(String status) {
    Color color;
    IconData iconData;

    switch (status) {
      case 'Finished':
        color = Colors.green;
        iconData = Icons.check_circle_outline;
        break;
      case 'Pending':
        color = Colors.orange;
        iconData = Icons.access_time;
        break;
      case 'Upcoming':
        color = Colors.blue;
        iconData = Icons.event_available;
        break;
      default:
        color = Colors.grey;
        iconData = Icons.error_outline;
        break;
    }

    return {
      "color": color,
      "icon": iconData,
    };
  }
}

// Appointment Model
class Appointment {
  final String subject;
  final String branch;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  Appointment({
    required this.subject,
    required this.branch,
    required this.startTime,
    required this.endTime,
    required this.status,
  });
}

// Sample appointment data
List<Appointment> getCalendarData() {
  return <Appointment>[
    Appointment(
      startTime: DateTime(2024, 9, 2, 10, 30),
      branch: "Maharaj",
      endTime: DateTime(2024, 9, 2, 11, 30),
      subject: 'Guccy (Ragdoll Cat) - Hair cut',
      status: 'Finished',
    ),
    Appointment(
      startTime: DateTime(2024, 9, 2, 11, 45),
      endTime: DateTime(2024, 9, 2, 12, 30),
      branch: "Yogichowk",
      subject: 'Blacky (Afghan Hound) - Tooth cleaning',
      status: 'Pending',
    ),
    Appointment(
      startTime: DateTime(2024, 9, 4, 10, 30),
      branch: "Maharaj",
      endTime: DateTime(2024, 9, 4, 11, 30),
      subject: 'Guccy (Ragdoll Cat) - Hair cut',
      status: 'Finished',
    ),
    Appointment(
      startTime: DateTime(2024, 9, 7, 11, 45),
      endTime: DateTime(2024, 9, 7, 12, 30),
      branch: "Yogichowk",
      subject: 'Blacky (Afghan Hound) - Tooth cleaning',
      status: 'Pending',
    ),
    Appointment(
      startTime: DateTime(2024, 9, 20, 10, 30),
      branch: "Maharaj",
      endTime: DateTime(2024, 9, 20, 11, 30),
      subject: 'Guccy (Ragdoll Cat) - Hair cut',
      status: 'Finished',
    ),
    Appointment(
      startTime: DateTime(2024, 9, 20, 11, 45),
      endTime: DateTime(2024, 9, 20, 12, 30),
      branch: "Yogichowk",
      subject: 'Blacky (Afghan Hound) - Tooth cleaning',
      status: 'Pending',
    ),
    Appointment(
      startTime: DateTime(2024, 9, 21, 10, 45),
      endTime: DateTime(2024, 9, 21, 12, 30),
      branch: "Maharaj",
      subject: 'Daisy (Afghan Hound) - Tooth cleaning',
      status: 'Upcoming',
    ),
    Appointment(
      startTime: DateTime(2024, 10, 21, 10, 30),
      branch: "Maharaj",
      endTime: DateTime(2024, 10, 21, 11, 30),
      subject: 'Guccy (Ragdoll Cat) - Hair cut',
      status: 'Finished',
    ),
    Appointment(
      startTime: DateTime(2024, 10, 5, 11, 45),
      endTime: DateTime(2024, 10, 5, 12, 30),
      branch: "Yogichowk",
      subject: 'Blacky (Afghan Hound) - Tooth cleaning',
      status: 'Pending',
    ),
    Appointment(
      startTime: DateTime(2024, 11, 9, 10, 45),
      endTime: DateTime(2024, 11, 9, 12, 30),
      branch: "Maharaj",
      subject: 'Daisy (Afghan Hound) - Tooth cleaning',
      status: 'Upcoming',
    ),
    Appointment(
      startTime: DateTime(2024, 9, 9, 10, 30),
      branch: "Maharaj",
      endTime: DateTime(2024, 9, 9, 11, 30),
      subject: 'Guccy (Ragdoll Cat) - Hair cut',
      status: 'Finished',
    ),
    Appointment(
      startTime: DateTime(2024, 9, 20, 11, 45),
      endTime: DateTime(2024, 9, 20, 12, 30),
      branch: "Yogichowk",
      subject: 'Blacky (Afghan Hound) - Tooth cleaning',
      status: 'Pending',
    ),
    Appointment(
      startTime: DateTime(2024, 9, 22, 10, 45),
      endTime: DateTime(2024, 9, 22, 12, 30),
      branch: "Maharaj",
      subject: 'Daisy (Afghan Hound) - Tooth cleaning',
      status: 'Upcoming',
    ),
  ];
}
