import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Model/Task.dart';
import '../Themes.dart';

class Tasktile extends StatelessWidget {
  final Task? task;

  Tasktile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 0.2,
              ),
            ],
            borderRadius: BorderRadius.circular(15),
            color: Get.isDarkMode ? tileDarkColor : Colors.white,
            border: Border(
                right: BorderSide(
              color: _getBGClr(task?.priority ?? 0, task?.isCompleted ?? 0),
              width: 20,
            ))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task?.title ?? "",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    )),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Get.isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[700],
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${task!.startTime}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 13,
                            color: Get.isDarkMode
                                ? Colors.grey[300]
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Icon(
                        Icons.date_range_outlined,
                        color: Get.isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[700],
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${task!.date}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 13,
                            color: Get.isDarkMode
                                ? Colors.grey[300]
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    task?.description ?? "",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Get.isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Get.isDarkMode
                  ? Colors.grey[300]!.withOpacity(0.7)
                  : Colors.grey[700]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task!.isCompleted == 1 ? "COMPLETED" : "TODO",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getBGClr(int pref, int taskStatus) {
    if (taskStatus == 1) {
      return Colors.green[800];
    } else {
      switch (pref) {
        case 0:
          return Colors.yellow[800];
        case 1:
          return Colors.orange[800];
        case 2:
          return Colors.red[800];
        default:
          return Colors.blue;
      }
    }
  }
}
