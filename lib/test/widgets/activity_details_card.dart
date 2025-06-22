
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onepluspay/features/Transactions/presentation/providers/transactions_provider.dart';

import '../data/health_details.dart';
import '../util/responsive.dart';
import 'custom_card_widget.dart';

class ActivityDetailsCard extends ConsumerWidget {
  const ActivityDetailsCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final healthDetails = HealthDetails();
    int count = ref.watch(pageProvider);
    List<ChartData> UserSummarires = count == 0 ?
    ref.watch(transactionProvider).UserSummarires: count == 1 ?
    ref.watch(transactionProvider).TransactionSummaries: count == 2 ?
    ref.watch(transactionProvider).EscrowSummaries: count == 3 ?
    ref.watch(transactionProvider).CardSummaries: count == 4 ?
    ref.watch(transactionProvider).PaybillSummaries: count == 5 ?
    ref.watch(transactionProvider).PaymentSummaries :
    ref.watch(transactionProvider).NearMeSummaries

    ;

    String formattedBalance( double count) {
      return NumberFormat("#,##0.00", "en_US").format(count);}

    return Column(
      children: [
        if (!Responsive.isDesktop(context))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.menu,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                ),
              ),
              SizedBox()
            ],
          ),
        GridView.builder(
          itemCount: UserSummarires.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
            crossAxisSpacing: Responsive.isMobile(context) ? 12 : 15,
            mainAxisSpacing: 12.0,
          ),
          itemBuilder: (context, index) => CustomCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.attach_money,
                  size: 20,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 4),
                  child: Text(
                    formattedBalance(UserSummarires[index].count) ,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  UserSummarires[index].label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
