
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepluspay/features/Auth/presentation/providers/User_provider.dart';
import 'package:onepluspay/features/Transactions/presentation/providers/transactions_provider.dart';

import '../../core/constants/theme.dart';
import '../../core/params/params.dart';
import '../../core/widgets/core/custom_button_2.dart';
import '../../core/widgets/core/textformfield.dart';
import '../util/responsive.dart';
import '../widgets/dashboard_widget.dart';
import '../widgets/side_menu_widget.dart';
import '../widgets/summary_widget.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _ResponsiveSignInScreenState();
}

class _ResponsiveSignInScreenState extends ConsumerState<SignIn> {
  bool obsecure = true;
  bool isLoading = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordNameController = TextEditingController();

  void _signIn(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));

    ref.read(transactionProvider).eitherFailureOrGetUsers(context, ref);


    final phone = _phoneController.text;
    final password = _passwordNameController.text;
    ref.watch(isLoader.notifier).state = true;

    ref.read(userProvider).updateUserParams(UserParams(
      phone_number: phone,
      password: password,
    ));

    // ref.read(userProvider).eitherFailureOrUserSignIn(context, ref);
    _saveCredentials(phone, password);
  }

  void _saveCredentials(String phone, String password) {
    // Save to secure storage or shared prefs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          return Row(
            children: [
              if (isDesktop)
                Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color(0xFFf4f4f4),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/oneplug.svg',
                        width: 500,
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: isDesktop ? 1 : 2,
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: isDesktop ? 50 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isDesktop)
                          SvgPicture.asset('assets/oneplug.svg', width: 100),
                        const SizedBox(height: 24),
                        !isDesktop ?
                        Text("Login into your account to continue", style: globalvariable.bodyMedium):
                        Text("Login into your account to continue", style: TextStyle(
                          fontSize :  14 ,
                          fontFamily : "sherika",
                          fontWeight : FontWeight.w500,
                          color : Color(0xFF888888),
                        ))
                        ,
                        const SizedBox(height: 24),
                        !isDesktop ?
                        Text("Code number", style: globalvariable.bodySmall):
                        Text("Code number", style: TextStyle(
                          fontSize : 14,
                          fontFamily : "sherika",
                          fontWeight : FontWeight.w500,
                          color : Colors.black,
                        )),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: '08143234239',
                        ),
                        const SizedBox(height: 16),
                        !isDesktop ?
                        Text("Password", style: globalvariable.bodySmall):
                        Text("Password", style: TextStyle(
                          fontSize : 14,
                          fontFamily : "sherika",
                          fontWeight : FontWeight.w500,
                          color : Colors.black,
                        )),
                        CustomTextField(
                          controller: _passwordNameController,
                          hintText: '••••••••',
                          keyboard: TextInputType.visiblePassword,
                          isObscure: obsecure,
                          suffixIconData: obsecure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onTap: () => setState(() => obsecure = !obsecure),
                        ),
                        const SizedBox(height: 8),

                        const SizedBox(height: 30),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton2(
                                                      onPressed: () => _signIn(context),
                                                      title: 'Login',
                                                      tag: 'buttons',
                                                    ),
                        const SizedBox(height: 40),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}



class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    bool loading = ref.watch(isLoader);

    final isDesktop = Responsive.isDesktop(context);


    return Scaffold(
      drawer: !isDesktop
          ? const SizedBox(
              width: 250,
              child: SideMenuWidget(),
            )
          : null,
      endDrawer: Responsive.isMobile(context)
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const SummaryWidget(),
            )
          : null,
      body: SafeArea(
        child:  Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: SideMenuWidget(),
                ),
              ),
            Expanded(
              flex: 7,
              child: loading ?Center(
                child: CircularProgressIndicator(),
              ):DashboardWidget(),
            ),
            if (isDesktop)
              Expanded(
                flex: 3,
                child: loading ?Center(
                  child: CircularProgressIndicator(),
                ):SummaryWidget(),
              ),
          ],
        ),
      ),
    );
  }
}
