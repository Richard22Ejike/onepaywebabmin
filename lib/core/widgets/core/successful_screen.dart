import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepluspay/core/widgets/core/saveandopendocument.dart';

import 'package:onepluspay/features/Auth/business/entities/entity.dart';
import 'package:onepluspay/features/Auth/presentation/providers/User_provider.dart';
import 'package:onepluspay/features/Transactions/presentation/providers/transactions_provider.dart';

import '../../constants/theme.dart';
import '../../../features/skeletion/widgets/skeleton.dart';
import 'customButton.dart';


class SuccessfulScreen extends ConsumerWidget {
  final String title;
  final String body;
  final bool isShare;
  const SuccessfulScreen({Key? key, required this.title, required this.body, required this.isShare}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    UserEntity? user = ref.watch(userProvider).User;
    return Scaffold(
      body: SafeArea(
        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/confetti.svg', ),
                  Text(
                      title,

                      // Semibold/Foodgrab SB 6
                      style: globalvariable.bodyLarge
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: 350.w,

                    child: Text(
                        body,
                        textAlign: TextAlign.center,
                        // Semibold/Foodgrab SB 9
                        style:globalvariable.bodyMedium
                    ),
                  ),


                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 47.0.h,horizontal: 30.w),
                child: Column(
                  children: [
                    isShare ?SizedBox(
                      width: 300.w,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFFFFF),
                              shape: const RoundedRectangleBorder(
                                  side:
                                  BorderSide(
                                      color: Color(0xFF9D2EC1),
                                      width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(30)))
                          ),
                          onPressed: () async {
                            ref.read(transactionProvider).eitherFailureOrTransactions(context, ref, user!.customerId);
                            }, child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                            SvgPicture.asset('assets/share.svg', color: globalvariable.primarycolor,),
                             Text('Share',style: globalvariable.labelMedium)
                        ],
                      )),
                    ): SizedBox(),
                    SizedBox(
                      height: 25.h,
                    ),
                    CustomButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Skeleton()));

                        }      , title: 'Done'),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
