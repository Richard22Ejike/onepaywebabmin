import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:onepluspay/core/constants/theme.dart';
import 'package:onepluspay/core/widgets/core/Appbar.dart';
import 'package:onepluspay/core/widgets/core/enter_pin.dart';
import 'package:onepluspay/features/Auth/presentation/providers/User_provider.dart';
import 'package:onepluspay/features/Transactions/presentation/providers/transactions_provider.dart';
import 'package:onepluspay/features/paybills/presentation/providers/paybill_provider.dart';

import '../../../features/skeletion/widgets/skeleton.dart';

class SummaryScreen extends ConsumerWidget {
  final String title;
  final String image;
  final int KeyPage;
  const SummaryScreen({Key? key, required this.title,required this.image,required this.KeyPage, }) : super(key: key);
  String formatter(balance) => NumberFormat("#,##0.00", "en_US").format(balance);
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: OnePlugAppBar(title: 'Summary', onPressed: () {Navigator.of(context).pop();  },),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  if(KeyPage < 2)
                  Container(
                    height: 72.h,
                    width: 72.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(72.h),
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 42.h,
                        width: 42.w,
                        child: SvgPicture.asset(
                          'assets/send-alt.svg',
                          height: 42.h,
                          width: 42.w,
                          fit: BoxFit.contain, // Adjust this property
                        ),
                      ),
                    ),
                  ),
                  if(KeyPage < 2)
                  Text(
                    'N${formatter(ref.read(transactionProvider).transactionParams.amount ?? 0)}', style: TextStyle(
                    fontSize : 20.sp,
                    fontFamily : 'sherika',
                    fontWeight : FontWeight.w700,
                    color : Color(0xFF101010),

                  ),),

                  if(KeyPage >= 2)
                    Container(
                      height: 92.h,
                      width: 92.h,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(92.h),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ref.read(paybillsProvider).paybillsParams.serviceType == 'electricity'? SizedBox(
                            height: 42.h,
                            width: 42.w,
                            child: SvgPicture.asset(
                              'assets/send-alt.svg',
                              height: 42.h,
                              width: 42.w,
                              fit: BoxFit.contain, // Adjust this property
                            ),
                          ):Container(
                            height:title == 'Dstv'||title == 'StarTime' || title =='Gotv'?73.h:36.w,
                            width: title == 'Dstv'||title == 'StarTime' || title =='Gotv'?73.h:36.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(title == 'Dstv'||title == 'StarTime' || title =='Gotv'?
                                7.h:36.w),
                                image: DecorationImage(
                                    alignment: Alignment.center,
                                    image: AssetImage(image,),fit: BoxFit.contain,)
                            ),
                          ),
                          title == 'Dstv'||title == 'StarTime' || title =='Gotv'?SizedBox():SizedBox(height: 5.h,),
                          title == 'Dstv'||title == 'StarTime' || title =='Gotv'?SizedBox():
                          Text(title,style: globalvariable.bodySmall,overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                    ),
                  if(KeyPage >= 2)
                  Text(
                    'N${formatter(ref.read(paybillsProvider).paybillsParams.amount?? 0)}', style: TextStyle(
                    fontSize : 20.sp,
                    fontFamily : 'sherika',
                    fontWeight : FontWeight.w700,
                    color : Color(0xFF101010),

                  ),),
                  SizedBox(
                    height: 30.h,
                  ),
                  if(KeyPage >= 2)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Service', style: globalvariable.bodySmall,),
                          Text(ref.read(paybillsProvider).paybillsParams.serviceType!, style: globalvariable.bodySmall,)
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Amount', style: globalvariable.bodySmall,),
                          Text('N${formatter(ref.read(paybillsProvider).paybillsParams.amount! ?? 0)}', style: globalvariable.bodySmall,)
                        ],
                      ),
                    ],
                  ),
                  if(KeyPage < 2)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Account number', style: globalvariable.bodySmall,),
                          Text(ref.read(transactionProvider).transactionParams.accountNumber.toString(), style: globalvariable.bodySmall,)
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Account name', style: globalvariable.bodySmall,),
                          Text(ref.read(transactionProvider).transactionParams.name!, style: globalvariable.bodySmall,)
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Amount', style: globalvariable.bodySmall,),
                          Text('N${formatter(ref.read(transactionProvider).transactionParams.amount?? 0)}', style: globalvariable.bodySmall,)
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Transaction fee', style: globalvariable.bodySmall,),
                          Text('Free', style: globalvariable.bodySmall,)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method',style: globalvariable.displayLarge.copyWith(color: Colors.black),),
                      SizedBox()
                    ],
                  ),  SizedBox(
                    height: 20.h,
                  ),

                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                      side: BorderSide(
                          width: 1,
                          color: globalvariable.primarycolor,style: BorderStyle.solid
                      )
                    ),
                    leading: CircleAvatar(
                      child: SvgPicture.asset('assets/card.svg'),
                      backgroundColor: Color.fromARGB(255, 231, 205, 240),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Wallet', style: globalvariable.bodySmall.copyWith(fontSize: 16.sp),),
                        Text('N${ref.watch(userProvider).User?.formattedBalance}', style: globalvariable.bodyMedium,)
                      ],
                    ),
                    trailing: SvgPicture.asset('assets/check-circle.svg'),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                        side: BorderSide(
                            width: 1,
                            color: globalvariable.primarycolor,style: BorderStyle.solid
                        )
                    ),
                    leading: CircleAvatar(
                      child: SvgPicture.asset('assets/card.svg'),
                      backgroundColor: Color.fromARGB(255, 231, 205, 240),
                    ),
                    title: Text('Card', style: globalvariable.bodySmall.copyWith(fontSize: 16.sp),),
                    trailing: SvgPicture.asset('assets/radio-button.svg'),
                  ),

                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterPinScreen(KeyPage: KeyPage,)));
                }, child: Text(
                  'Pay',
                  style: globalvariable.displayMedium,
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
