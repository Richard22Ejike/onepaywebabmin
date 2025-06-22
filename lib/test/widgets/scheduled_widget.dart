
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepluspay/features/Transactions/presentation/providers/transactions_provider.dart';
import 'package:onepluspay/test/const/constant.dart';
import 'package:onepluspay/test/data/schedule_task_data.dart';
import 'package:onepluspay/test/widgets/custom_card_widget.dart';

class Scheduled extends ConsumerWidget {
  const Scheduled({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

   final day = ref.watch(transactionProvider).lastThreePayments;
    int count = ref.watch(pageProvider);
    final datas = count == 0 ?
    ref.watch(transactionProvider).lastThreeUsers: count == 1 ?
    ref.watch(transactionProvider).lastThreeTransactions: count == 2 ?
    ref.watch(transactionProvider).lastThreeEscrows: count == 3 ?
    ref.watch(transactionProvider).lastThreeCards: count == 4 ?
    ref.watch(transactionProvider).lastThreePaybill: count == 5 ?
    ref.watch(transactionProvider).lastThreePayments :
    ref.watch(transactionProvider).lastThreeNearMe
    ;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Scheduled",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        const SizedBox(height: 6),
        for (var data in datas?? [])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CustomCard(
              color: primaryColor.withOpacity(0.2),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          count == 1 || count == 3 || count == 4 || count == 5? data.name :
                          count == 2 ? data.senderName: count == 6 ? data. productName:
                          '${data.firstName} ${data.lastName}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500,color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                              formatDate(
                                count == 1 ? data.dateSent :
                                count == 2 ? data.created_at :
                                count == 3 ? data.dateCreated :
                                count == 4 ? data.orderDate :
                                count == 5 ? (data.createdAt?.toIso8601String() ?? 'nan') :
                                count == 6 ?  (data.createdAt?.toIso8601String() ?? 'nan')   :
                                data.created,
                              ),
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
