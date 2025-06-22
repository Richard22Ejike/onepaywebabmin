import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onepluspay/core/constants/theme.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/params/params.dart';
import '../../providers/User_provider.dart';
import '../../providers/timer_provider.dart'; // Import the timer provider

class VerifyResetPasswordScreen extends ConsumerWidget {
   VerifyResetPasswordScreen({Key? key}) : super(key: key);
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = ref.watch(isLoader);

    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: globalvariable.primarycolor),
      borderRadius: BorderRadius.circular(8),
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Text(
              "Verify your email address",
              style: globalvariable.bodyLarge,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "A message with an OTP has been sent to your email address.",
              style: globalvariable.bodyMedium,
            ),
            SizedBox(
              height: 10.h,
            ),
            Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) {
                ref.read(userProvider).updateUserParams(UserParams(
                    email: ref.read(userProvider).userParams.email,
                    otp: pin
                ));
              },
              keyboardType: TextInputType.number,
              onChanged: (val) {
                if (val.length == 6) {
                  ref.read(userProvider).updateUserParams(UserParams(
                      email: ref.read(userProvider).userParams.email,
                      otp: val
                  ));
                }
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.watch(isLoader.notifier).state = true;


                  log(ref.read(userProvider).userParams.otp!);
                  log(ref.read(userProvider).userParams.email!);
                  ref.read(userProvider).eitherFailureOrVerifyResetPassword(false,context, ref);
                },
                child: Text(
                  'Verify',
                  style: globalvariable.displayMedium,
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Didn’t receive a code? ',
                  style: globalvariable.bodySmall,
                ),
                SizedBox(width: 1.w),
                timerState.isActive
                    ? Text(
                  'Resend in ${timerState.secondsRemaining}s',
                  style: globalvariable.bodySmall,
                )
                    : InkWell(
                  onTap: () {
                    timerNotifier.startTimer();
                    ref.read(userProvider).eitherFailureOrForgotPasswordScreen(context, ref, true);
                  },
                  child: Text(
                    'Resend',
                    textAlign: TextAlign.center,
                    style: globalvariable.labelSmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
