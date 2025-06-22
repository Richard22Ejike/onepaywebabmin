import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Auth/business/entities/entity.dart';
import '../../Auth/presentation/providers/User_provider.dart';
import '../../Escrow/presentation/providers/escrow_provider.dart';
import '../providers/bottom_bar_selector_provider.dart';
import 'custom_bottom_bar_icon_widget.dart';




class CustomBottomBarWidget extends ConsumerWidget {
  const CustomBottomBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    UserEntity? user = ref.read(userProvider).User;
    final counterProvider = ref.watch(counter);

    return SafeArea(
      child: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomBottomBarIconWidget(
              iconDataSelected: Icons.home,
              iconDataUnselected: Icons.search_outlined,
              callback: () {
                 ref.watch(counter.notifier).state = 0;
              },
              isSelected: counterProvider == 0, IconName: 'assets/home.svg', Name: 'Home',
            ),
            CustomBottomBarIconWidget(
              iconDataSelected: Icons.menu,
              iconDataUnselected: Icons.menu,
              callback: () {

                ref.watch(counter.notifier).state = 1;
              },
              isSelected: counterProvider == 1, IconName: 'assets/card.svg', Name: 'POS',
            ),
            CustomBottomBarIconWidget(
              iconDataSelected: Icons.search_outlined,
              iconDataUnselected: Icons.search_outlined,
              callback: () {
                ref.watch(counter.notifier).state = 2;
                ref.read(escrowProvider).eitherFailureOrEscrows(context, ref,user!.customerId);
              },
              isSelected: counterProvider == 2, IconName: 'assets/switch-diagonal.svg', Name: 'Escrow',
            ),
            CustomBottomBarIconWidget(
              iconDataSelected: Icons.menu,
              iconDataUnselected: Icons.menu,
              callback: () {
                ref.watch(counter.notifier).state = 3;
              },
              isSelected: counterProvider == 3, IconName: 'assets/file.svg', Name: 'Pay bills',
            ),
            CustomBottomBarIconWidget(
              iconDataSelected: Icons.menu,
              iconDataUnselected: Icons.menu,
              callback: () {
                ref.watch(counter.notifier).state = 4;
              },
              isSelected: counterProvider == 4, IconName: 'assets/user.svg', Name: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
