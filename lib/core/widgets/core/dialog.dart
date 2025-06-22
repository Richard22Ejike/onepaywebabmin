import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';


void showSportbooSnackBar(
    String message,
    Function(String id) onView, {
      Duration duration = const Duration(seconds: 4),
    }) {
  SmartDialog.showNotify(
      alignment: Alignment.topCenter,
      msg: message,
      notifyType: NotifyType.error,
      displayTime: duration,

      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 5, 16, 0),

            // width: 200, height: 100,
            child: SportbooSnackBar(
              message: message,
              onView: onView,
            ),
          ),
        );
      });
}



class SportbooSnackBar extends StatelessWidget {
  final String message;
  final Function(String id) onView;

  const SportbooSnackBar({super.key, required this.message, required this.onView});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(2, 2, 16, 2),
    decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16)
    ),
    child: Row(
      children: [


        Expanded(
          child: Text(message, style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.brown,
              fontFamily: 'Inter'),),
        ),

        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              onTap: () {onView('');},
              child: Text('View',
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontFamily: 'Inter')),
            )),
      ],
    ),
  );
}
