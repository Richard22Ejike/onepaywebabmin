import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onepluspay/core/constants/theme.dart';
import 'package:onepluspay/core/params/params.dart';
import 'package:onepluspay/core/widgets/core/Appbar.dart';
import 'package:onepluspay/core/widgets/core/summary_screen.dart';
import 'package:onepluspay/features/Auth/business/entities/entity.dart';
import 'package:onepluspay/features/Auth/presentation/providers/User_provider.dart';

import '../../../features/Transactions/presentation/providers/transactions_provider.dart';
import 'customButton.dart';

class AmountScreen extends ConsumerStatefulWidget {
  const AmountScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends ConsumerState<AmountScreen> {
  TextEditingController accountController = TextEditingController(text: '0');
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
  double textWidth = 70;

  @override
  Widget build(BuildContext context) {
    void updateAccountController(String value) {
      if (value == '🗙') {
        setState(() {
          textWidth = 70; // Increase the width
        });
        accountController.text = '0';
      } else if (value == '⌫') {
        if (accountController.text.length > 1) {
          setState(() {
            textWidth -= 10; // Increase the width
          });
          accountController.text = accountController.text.substring(0, accountController.text.length - 1);
        } else {
          accountController.text = '0';
        }
      } else {
        if (accountController.text == '0') {
          accountController.text = value;
        } else {
          accountController.text += value;
          setState(() {
            textWidth += 10; // Increase the width
          });
        }
      }
    }
    UserEntity? user = ref.watch(userProvider).User;

    return Scaffold(
      appBar: OnePlugAppBar(
        title: 'Send money',
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 340.w,
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 8,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Color(0xFFE7CDF0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Available balance', style: globalvariable.bodySmall),
                  Text('NGN ${user?.formattedBalance}', style: globalvariable.bodySmall,)
                ],
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Text('Enter amount', style: globalvariable.bodySmall.copyWith(fontSize: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 0,bottom: 13.h),
                  child: Text('NGN', style: globalvariable.bodyLarge.copyWith(fontSize: 20),),
                ),
                SizedBox(
                  height: 70.h,
                  width: textWidth.w,
                  child: TextField(
                    controller: accountController,
                    keyboardType: TextInputType.none,
                    style: globalvariable.bodyLarge,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40.h,
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
                          updateAccountController(numberPad[index]);
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
            SizedBox(
              height: 10.h,
            ),
            CustomButton(
                onPressed: (){
                  log(ref.read(transactionProvider).transactionParams.name!);
                  log(accountController.text);
                  ref.read(transactionProvider).updateTransactionParams(
                      TransactionParams(
                        name: ref.read(transactionProvider).transactionParams.name,
                        accountNumber: ref.read(transactionProvider).transactionParams.accountNumber,
                        narration: ref.read(transactionProvider).transactionParams.narration,
                        bankCode: ref.read(transactionProvider).transactionParams.bankCode,
                        amount:int.parse(accountController.text) ,
                        customerId: ref.read(transactionProvider).transactionParams.customerId,
                        accountBank: ref.read(transactionProvider).transactionParams.bankCode,
                        key: ref.read(transactionProvider).transactionParams.key

                      )
                  );
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SummaryScreen(title: '', image: '', KeyPage: 0,)));

                }      , title: 'Proceed'),

          ],
        ),
      ),
    );
  }
}
