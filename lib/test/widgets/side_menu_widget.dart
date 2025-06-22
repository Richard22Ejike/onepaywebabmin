
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepluspay/test/const/constant.dart';
import 'package:onepluspay/test/data/side_menu_data.dart';

import '../../features/Auth/presentation/providers/User_provider.dart';
import '../../features/Transactions/presentation/providers/transactions_provider.dart';

class SideMenuWidget extends ConsumerStatefulWidget {
  const SideMenuWidget({super.key});

  @override
  ConsumerState<SideMenuWidget> createState() => SideMenuWidgetState();
}

class SideMenuWidgetState extends ConsumerState<SideMenuWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: cardBackgroundColor,
      child: ListView.builder(
        itemCount: data.menu.length,
        itemBuilder: (context, index) => buildMenuEntry(data, index),
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
        color: isSelected ? selectionColor : Colors.transparent,
      ),
      child: InkWell(

        onTap: () => setState(() {
          if (index == 1){
            ref
                .watch(isLoader.notifier)
                .state = true;
            ref.read(transactionProvider).eitherFailureOrTransactions(context, ref, '');
            print('transaction');
          }
          if (index == 2){
            ref
                .watch(isLoader.notifier)
                .state = true;
            ref.read(transactionProvider).eitherFailureOrEscrows(context, ref, '');
            print('Escrows');
          }
          if (index == 3){
            ref
                .watch(isLoader.notifier)
                .state = true;
            ref.read(transactionProvider).eitherFailureOrCards(context, ref, '');
            print('Cards');
          }
          if (index == 4){
            print('Paybills');
            ref
                .watch(isLoader.notifier)
                .state = true;
            ref.read(transactionProvider).eitherFailureOrPaybills(context, ref);
          }
          if (index == 5){
            print('Payment Links');
            ref
                .watch(isLoader.notifier)
                .state = true;
            ref.read(transactionProvider).eitherFailureOrPaymentLinks(context, ref);
          }
          if (index == 6){
            print('Near Me');
            ref
                .watch(isLoader.notifier)
                .state = true;
            ref.read(transactionProvider).eitherFailureOrNearMe(context, ref, '');
          }
          selectedIndex = index;
          ref.read(pageProvider.notifier).state = index;



        }),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Icon(
                data.menu[index].icon,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              data.menu[index].title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
