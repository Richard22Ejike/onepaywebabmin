import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/theme.dart';
import '../../../features/skeletion/widgets/skeleton.dart';


class failedScreen extends StatelessWidget {
  final String error;
  const failedScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child:  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 20,),
                    Stack(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/alert-circle-down.svg',  )),
                        Align(
                           alignment: Alignment.center,
                           child:Padding(
                             padding: const EdgeInsets.only(top: 9.0),
                             child: SvgPicture.asset('assets/alert-circle-up.svg', ),
                           )),
                        Align(
                          alignment: Alignment.center,

                          child:Padding(
                            padding: const EdgeInsets.only(top: 11.0),
                            child: SvgPicture.asset('assets/alert-circle.svg', ),
                          )),
                      ],
                    ),
                    Text(
                        "Transaction Failed",

                        // Semibold/Foodgrab SB 6
                        style: globalvariable.bodyLarge
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                        error,

                        // Semibold/Foodgrab SB 9
                        style:globalvariable.bodyMedium
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child:     Hero(

                        tag: 'button',
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: globalvariable.backgroundcolor,
                                shape: const RoundedRectangleBorder(
                                    side:
                                    BorderSide(
                                        color: globalvariable.primarycolor,
                                        width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(20)))
                            ),
                            onPressed: (){}, child: Text(
                          "Try Again",
                          textAlign: TextAlign.center,
                          style: globalvariable.labelMedium,
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Skeleton()));
                        }, child: Text(
                        'Done',
                        style: globalvariable.displayMedium,
                      )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
