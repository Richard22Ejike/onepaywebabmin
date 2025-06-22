import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onepluspay/core/constants/theme.dart';
import 'package:onepluspay/core/params/params.dart';
import 'package:onepluspay/core/widgets/core/Appbar.dart';

import 'package:onepluspay/features/Auth/presentation/providers/User_provider.dart';

import 'package:onepluspay/features/skeletion/widgets/skeleton.dart';

import '../../../../../core/widgets/core/customButton.dart';
import '../../../../../core/widgets/core/custom_button_2.dart';
import '../../../../../core/widgets/core/textformfield.dart';

class AuthSetPin extends ConsumerStatefulWidget {


  AuthSetPin({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthSetPin> createState() => _AuthSetPinState();
}

class _AuthSetPinState extends ConsumerState<AuthSetPin> {
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isLoading =  ref.watch(isLoader);
    return Scaffold(
      appBar: OnePlugAppBar(title: '', onPressed: () {Navigator.of(context).pop();  },),
      body:SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  SvgPicture.asset('assets/oneplug.svg'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                      "Enter login detail to set pin",

                      // Semibold/Foodgrab SB 9
                      style : globalvariable.bodyMedium
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      "Phone number",
                      style: globalvariable.bodySmall
                  ),
                  CustomTextField(controller: _phoneController,hintText: '08143234239',),
                  Text(
                      "Password",
                      style: globalvariable.bodySmall
                  ),
                  CustomTextField(controller: _passwordNameController,hintText: 'e.g.Steve',),
                 
                  SizedBox(
                    height: 30.h,
                  ),
                  isLoading ? const Center(
                    child: CircularProgressIndicator(),
                  ) :CustomButton2(
                    onPressed: (){

                    }      , title: 'Proceed',
                    tag: 'buttons',),

                ],
              ),
          

            ],
          ),
        ),
      ),
    );
  }
}
