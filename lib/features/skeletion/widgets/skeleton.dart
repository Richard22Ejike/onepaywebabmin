import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepluspay/core/params/params.dart';
import 'package:onepluspay/features/Account/presentation/providers/account_provider.dart';
import 'package:onepluspay/features/Auth/business/entities/entity.dart';
import 'package:onepluspay/features/Auth/presentation/providers/User_provider.dart';

import 'package:onepluspay/features/card/presentation/providers/card_provider.dart' hide counter;
import 'package:onepluspay/features/card/presentation/providers/payment_link_provider.dart';

import '../../Escrow/presentation/providers/escrow_provider.dart';
import '../../Transactions/presentation/providers/transactions_provider.dart';
import '../providers/bottom_bar_selector_provider.dart';
import 'custom_bottom_bar_widget.dart';


List<Widget> pages = const [

];

class Skeleton extends ConsumerStatefulWidget {
  const Skeleton({Key? key}) : super(key: key);

  @override
  ConsumerState<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends ConsumerState<Skeleton> {

  @override
  void initState(){

    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() {
      UserEntity? user = ref.read(userProvider).User;

      if (user != null) {
        // Load the necessary data based on the user's customerId
        ref.read(transactionProvider).eitherFailureOrTransactions(context, ref, user.customerId);
        ref.read(escrowProvider).eitherFailureOrEscrows(context, ref, user.customerId);
        ref.read(cardProvider).eitherFailureOrCard(user.customerId);
        ref.read(paymentLinkProvider).eitherFailureOrPaymentLink(user.customerId);
        ref.read(accountProvider).eitherFailureOrNotification(user.customerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedPage =  ref.watch(counter);
    return Scaffold(
      body: PageTransitionSwitcher(
        reverse: true,
        duration: const Duration(milliseconds: 800),
        transitionBuilder: (
            Widget child,
            Animation<double> primaryAnimation,
                Animation<double> secondaryAnimation) => SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.vertical,
                     child: child,
        ),
        child:
        pages[selectedPage],

      ),
      bottomNavigationBar: const CustomBottomBarWidget(),
    );
  }
}