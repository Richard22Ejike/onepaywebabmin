import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onepluspay/core/constants/theme.dart';
import '../../../../../core/params/params.dart';
import '../../../../../core/widgets/core/customButton.dart';
import '../../../../../core/widgets/core/textformfield.dart';
import '../../providers/User_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(isLoader);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Text(
              "Reset your password",
              style: globalvariable.bodyLarge,
            ),
            SizedBox(height: 5.h),
            Text(
              "Enter your new password below.",
              style: globalvariable.bodyMedium,
            ),
            SizedBox(height: 20.h),
            Text(
              "Password",
              style: globalvariable.bodySmall,
            ),
            CustomTextField(
              controller: _passwordController,
              hintText: 'New Password',
              keyboard: TextInputType.visiblePassword,
              isObscure: _obscurePassword,
              suffixIconData: _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            SizedBox(height: 20.h),
            Text(
              "Confirm Password",
              style: globalvariable.bodySmall,
            ),
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm New Password',
              keyboard: TextInputType.visiblePassword,
              isObscure: _obscureConfirmPassword,
              suffixIconData: _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              onTap: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            SizedBox(height: 30.h),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
              onPressed: () {
                if (_passwordController.text == _confirmPasswordController.text) {

                  ref.read(userProvider).updateUserParams(UserParams(
                      email: ref.read(userProvider).userParams.email,
                      otp: ref.read(userProvider).userParams.otp,
                    password: _passwordController.text,
                  ));
                  ref.read(userProvider).eitherFailureOrResetForgotPassword(context, ref);
                } else {
                  // Display error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
              title: 'Reset Password',
            ),
          ],
        ),
      ),
    );
  }
}
