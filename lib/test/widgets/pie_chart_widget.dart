
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/Transactions/presentation/providers/transactions_provider.dart';
import '../const/constant.dart';
import '../data/pie_chart_data.dart';

class Chart extends ConsumerWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    int count = ref.watch(pageProvider);
    List<PieChartSectionData>? pieChartData = count == 0 ?
    ref.watch(transactionProvider).UserPieChart: count == 1 ?
    ref.watch(transactionProvider).TransactionPieChart: count == 2 ?
    ref.watch(transactionProvider).EscrowPieChart: count == 3 ?
    ref.watch(transactionProvider).CardPieChart: count == 4 ?
    ref.watch(transactionProvider).PaybillPieChart: count == 5 ?
    ref.watch(transactionProvider).paymentTypePie :
    ref.watch(transactionProvider).NearMePieChart
    ;
    if (pieChartData == null ||pieChartData.isEmpty ) {
      pieChartData = [
        PieChartSectionData(
          title: 'No data',
          value: 1,
          color: Colors.grey,
          radius: 25,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ];
    }

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: pieChartData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                  pieChartData!.first.title,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      fontSize: 11
                      ),
                ),
                const SizedBox(height: 8),
               Text("of 100%",   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                 fontSize: 10

                ),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
