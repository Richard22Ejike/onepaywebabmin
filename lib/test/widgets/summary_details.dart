
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../features/Transactions/presentation/providers/transactions_provider.dart';
import '../const/constant.dart';
import 'custom_card_widget.dart';

class SummaryDetails extends ConsumerWidget {
  const SummaryDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    int count = ref.watch(pageProvider);
    List<ChartData> UserSummaries = count == 0 ?
    ref.watch(transactionProvider).UserSummarires: count == 1 ?
    ref.watch(transactionProvider).TransactionSummaries: count == 2 ?
    ref.watch(transactionProvider).EscrowSummaries: count == 3 ?
    ref.watch(transactionProvider).CardSummaries: count == 4 ?
    ref.watch(transactionProvider).PaybillSummaries: count == 5 ?
    ref.watch(transactionProvider).PaymentSummaries :
    ref.watch(transactionProvider).NearMeSummaries
    ;

    return CustomCard(
      color: primaryColor.withOpacity(0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var summary in UserSummaries.take(3))
            buildDetails(
              summary.label,
              NumberFormat("#,##0.00", "en_US").format(summary.count),
            ),



        ],
      ),
    );
  }

  Widget buildDetails(String key, String value) {
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 15,
          child: Text(
            key,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}
