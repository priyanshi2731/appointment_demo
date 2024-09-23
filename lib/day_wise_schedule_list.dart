import 'package:appointment_demo/utils/common_images.dart';
import 'package:appointment_demo/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'appointment_calender.dart';
import 'controller/day_wise_schedule_list_controller.dart';

class DayWiseScheduleList extends StatefulWidget {
  const DayWiseScheduleList({super.key});

  @override
  State<DayWiseScheduleList> createState() => _DayWiseScheduleListState();
}

class _DayWiseScheduleListState extends State<DayWiseScheduleList> {
  DayWiseScheduleListController controller = Get.put(DayWiseScheduleListController());

  @override
  void initState() {
    super.initState();
    _populateAllHoursForDay();
  }

  void _populateAllHoursForDay() {
    DateTime day = DateTime.now();

    controller.allHoursInDay.clear(); // Clear previous entries
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        controller.allHoursInDay.add(DateTime(day.year, day.month, day.day, hour, minute));
      }
    }
  }

  void scrollToFirstDay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.scrollController.animateTo(
        controller.scrollController.position.minScrollExtent,
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
        automaticallyImplyLeading: false,
        title: UiUtils.fadeSwitcherWidget(
          duration: const Duration(milliseconds: 300),
          child: Text(
            controller.selectedDay,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF4E00),
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                      if (controller.scrollController.offset >= 500) {
                        if (!controller.showScrollToTopButton) {
                          controller.showScrollToTopButton = true;
                        }
                      } else {
                        if (controller.showScrollToTopButton) {
                          controller.showScrollToTopButton = false;
                        }
                      }

                      setState(() {});

                      return true;
                    },
                    child: ListView.separated(
                      controller: controller.scrollController,
                      itemCount: controller.allHoursInDay.length,
                      separatorBuilder: (context, index) => Divider(height: 0, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        DateTime day = controller.allHoursInDay[index];

                        List<Appointment> appointmentsForTime = controller.getAppointmentsForTime(day);

                        debugPrint("======$day");
                        debugPrint("${controller.todayAppointments.length}");

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Date header
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: appointmentsForTime.isEmpty
                                      ? Border(
                                          right: BorderSide(color: Colors.grey.shade200),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AnimatedDefaultTextStyle(
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      duration: const Duration(milliseconds: 250),
                                      child: Text(
                                        DateFormat('hh:mm').format(day),
                                        // textAlign: TextAlign.center,
                                      ),
                                    ).paddingOnly(right: 3.w),
                                    AnimatedDefaultTextStyle(
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF667085),
                                      ),
                                      duration: const Duration(milliseconds: 250),
                                      child: Text(
                                        DateFormat('a').format(day),
                                        // textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// Appointment List
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: appointmentsForTime.isNotEmpty
                                      ? Border(
                                          left: BorderSide(color: Colors.grey.shade200),
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: appointmentsForTime.isNotEmpty
                                    ? ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(10),
                                        itemCount: controller.todayAppointments.length,
                                        separatorBuilder: (BuildContext context, int index) {
                                          return const SizedBox(height: 15);
                                        },
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            margin: const EdgeInsets.only(left: 3),
                                            decoration: BoxDecoration(
                                              border: appointmentsForTime.isNotEmpty
                                                  ? const Border(
                                                      left: BorderSide(
                                                        color: Colors.green,
                                                        width: 2.3,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            child: ListTile(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                              title: Text(
                                                controller.todayAppointments[index].startTime.toString(),
                                                // controller.todayAppointments[index].subject,

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
                                                    controller.todayAppointments[index].branch,
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ).paddingOnly(bottom: 8),
                                                  Text.rich(
                                                    TextSpan(
                                                        text: controller.todayAppointments[index].status,
                                                        style: TextStyle(
                                                          fontSize: 11.sp,
                                                          fontWeight: FontWeight.w500,
                                                          // color: _getAppointmentStatusIcon(controller.todayAppointments[index].status)["color"],
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
                                                            text: '${DateFormat.jm().format(controller.todayAppointments[index].startTime)} - ${DateFormat.jm().format(controller.todayAppointments[index].endTime)}',
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
                                    : const SizedBox(
                                        child: CircularProgressIndicator(),
                                      ),
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
                      opacity: controller.showScrollToTopButton ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: () {
                          scrollToFirstDay();
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
      ),
    );
  }
}
