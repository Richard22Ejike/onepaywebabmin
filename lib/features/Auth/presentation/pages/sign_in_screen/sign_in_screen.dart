import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onepluspay/core/constants/theme.dart';
import 'package:onepluspay/core/params/params.dart';
import 'package:onepluspay/core/widgets/core/Appbar.dart';
import 'package:onepluspay/features/Auth/presentation/providers/User_provider.dart';
import '../../../../../core/widgets/core/custom_button_2.dart';
import '../../../../../core/widgets/core/textformfield.dart';
import '../../../../Account/presentation/providers/account_provider.dart';


class SignInScreen extends ConsumerStatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool obsecure = true;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordNameController = TextEditingController();
  late final LocalAuthentication auth;
  bool isAuthSupported = false;
  bool canCheckBiometrics = false;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();

    // Check if biometrics are supported and available
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        isAuthSupported = isSupported;
      });
    });

    auth.canCheckBiometrics.then((bool canCheck) {
      setState(() {
        canCheckBiometrics = canCheck;
      });
    });
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        await _loginWithSavedCredentials();
      }
    } catch (e) {
      print("Biometric authentication error: $e");
    }
  }

  Future<void> _loginWithSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('phone_number');
    final savedPassword = prefs.getString('password');

    if (savedPhone != null && savedPassword != null) {
      ref.watch(isLoader.notifier).state = true;
      ref.read(userProvider).updateUserParams(
        UserParams(
          phone_number: savedPhone,
          password: savedPassword,
        ),
      );
      ref.read(userProvider).eitherFailureOrUserSignIn(context, ref);
    } else {
      print("No saved credentials found.");
    }
  }

  Future<void> _saveCredentials(String phone, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone_number', phone);
    await prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(isLoader);
    final isBiometricEnabled = ref.watch(biometricProvider);
    return Scaffold(
      appBar: OnePlugAppBar(
        title: '',
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  SvgPicture.asset('assets/oneplug.svg'),
                  SizedBox(height: 5.h),
                  Text(
                    "Login into your account to continue",
                    style: globalvariable.bodyMedium,
                  ),
                  SizedBox(height: 10.h),
                  Text("Phone number", style: globalvariable.bodySmall),
                  CustomTextField(
                    controller: _phoneController,
                    hintText: '08143234239',
                  ),
                  Text("Password", style: globalvariable.bodySmall),
                  CustomTextField(
                    controller: _passwordNameController,
                    hintText: 'e.g. Steve',
                    keyboard: TextInputType.visiblePassword,
                    isObscure: obsecure,
                    suffixIconData: obsecure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onTap: () {
                      setState(() {
                        obsecure = !obsecure;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      InkWell(
                        onTap: () {

                        },
                        child: Text(
                          'Forgot Password?',
                          style: globalvariable.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                        children: [
                          CustomButton2(
                            onPressed: () {
                              log(isAuthSupported.toString());
                              log(canCheckBiometrics.toString());
                              log(isBiometricEnabled.toString());
                              final phone = _phoneController.text;
                              final password = _passwordNameController.text;
                              ref.watch(isLoader.notifier).state = true;
                              ref.read(userProvider).updateUserParams(
                                  UserParams(
                                    phone_number: phone,
                                    password: password,
                                  ));
                              ref.read(userProvider)
                                  .eitherFailureOrUserSignIn(context, ref);
                              _saveCredentials(phone, password);
                            },
                            title: 'Login',
                            tag: 'buttons',
                          ),
                          SizedBox(height: 40.h),
                       if (isAuthSupported && canCheckBiometrics && isBiometricEnabled)
                          InkWell(
                              onTap: authenticateWithBiometrics,
                              child: Image.asset('assets/biometric.png')),


                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Don’t have an Oneplug account?',
                    style: globalvariable.bodySmall,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Create One',
                    textAlign: TextAlign.center,
                    style: globalvariable.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
