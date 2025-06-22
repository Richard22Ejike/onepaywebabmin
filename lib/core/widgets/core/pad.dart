
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onepluspay/core/constants/theme.dart';

class Numpad extends StatelessWidget {

  final VoidCallback onTap;
  const Numpad({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> numberPad = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'x',
      '0',
      '⌫',
    ];
    return  Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: GridView.builder(
          itemCount: numberPad.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 7/4,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: onTap,
                child: Container(
                  height: 30,
                  child: Center(
                    child:

                    Text(
                      numberPad[index],
                      textAlign : TextAlign.center,
                       style:  TextStyle(
                         fontSize : 40.sp,
                         fontFamily : 'sherika',
                         fontWeight : FontWeight.w500,
                         color: (numberPad[index] == 'x' || numberPad[index] == '⌫') ? globalvariable.primarycolor : Color(0xFF383838),


                       ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

