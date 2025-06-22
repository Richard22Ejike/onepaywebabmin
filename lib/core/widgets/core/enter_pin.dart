import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onepluspay/core/constants/theme.dart';
import 'package:onepluspay/core/widgets/core/Appbar.dart';
import 'package:onepluspay/core/widgets/core/loader.dart';
import 'package:onepluspay/core/widgets/core/successful_screen.dart';
import 'package:onepluspay/features/Escrow/presentation/providers/escrow_provider.dart';
import 'package:onepluspay/features/paybills/presentation/providers/paybill_provider.dart';

import '../../../features/Auth/business/entities/entity.dart';
import '../../../features/Auth/presentation/providers/User_provider.dart';
import '../../../features/Transactions/presentation/providers/transactions_provider.dart';
import 'pad.dart';

class EnterPinScreen extends ConsumerStatefulWidget {
  final int KeyPage;
  const EnterPinScreen( {Key? key,required this.KeyPage,}) : super(key: key);

  @override
  ConsumerState<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends ConsumerState<EnterPinScreen> {

  TextEditingController accountController = TextEditingController(text: '0');
  int pinLength = 0;

  void updateAccountController(String value, String email) {
    if (value == 'X') {
      accountController.text = '0';
      pinLength = 0;
    } else if (value == '⌫') {
      if (accountController.text.length > 1) {
        accountController.text = accountController.text.substring(0, accountController.text.length - 1);
        pinLength--;
      } else {
        accountController.text = '0';
        pinLength = 0;
      }
    } else {
      if (accountController.text == '0') {
        accountController.text = value;
        pinLength = 1;
      } else {
        accountController.text += value;
        pinLength++;
      }
    }
    if(accountController.text.length >= 6){
      ref.read(transactionProvider).updateTransactionPin(
          pin: accountController.text
      );
      ref.read(paybillsProvider).updatePayBillsPin(
          pin: accountController.text
      );
      ref.read(escrowProvider).updateEscrowPin(pin: accountController.text);
      if(widget.KeyPage == 0){


      } if(widget.KeyPage == 1) {


      }
      if(widget.KeyPage == 2) {
        ref.read(paybillsProvider).eitherFailureOrPaybills(context, ref);
      }
      if(widget.KeyPage == 3) {
        ref.read(escrowProvider).eitherFailureOrMakeEscrow(context, ref,email);
      }
          }
    setState(() {}); // Trigger rebuild to update pin dots
  }

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
    '🗙',
    '0',
    '⌫',
  ];

  @override
  Widget build(BuildContext context) {
    bool isLoading =  ref.watch(isLoader)|| ref.watch(isEscrowLoader) || ref.watch(isBillLoader);
    UserEntity? user =  ref.watch(userProvider).User;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height:200.h ,
            ),
            Text('Enter Transaction PIN', style: TextStyle(
              fontSize : 20.sp,
              fontFamily : 'sherika',
              fontWeight : FontWeight.w700,
              color : Color(0xFF101010),

            ),),
            SizedBox(
              height:20.h ,
            ),
            isLoading ? Loader(): Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 6; i++)
                  Row(
                    children: [

                     SvgPicture.asset(
                        i < pinLength ? 'assets/pindotactive.svg' : 'assets/pindot.svg',
                        width: 15.w,
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      )
                    ],
                  ),

              ],
            ),
            SizedBox(
              height:20.h ,
            ),
            Text('Forgot PIN', style: globalvariable.labelMedium),
            SizedBox(
              height:20.h ,
            ),
            Padding(
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
                        onTap: () {
                          log('512');
                          updateAccountController(numberPad[index], user!.email);
                        },
                        child: Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              numberPad[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40.sp,
                                fontFamily: 'sherika',
                                fontWeight: FontWeight.w500,
                                color: (numberPad[index] == '🗙' || numberPad[index] == '⌫') ? globalvariable.primarycolor : Color(0xFF383838),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
