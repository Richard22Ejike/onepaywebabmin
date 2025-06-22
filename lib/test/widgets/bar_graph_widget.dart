
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepluspay/features/Transactions/presentation/providers/transactions_provider.dart';

import '../data/bar_graph_data.dart';
import '../model/bar_graph_model.dart';
import '../model/graph_model.dart';
import 'custom_card_widget.dart';

class BarGraphCard extends ConsumerWidget {
  const BarGraphCard({super.key});

  @override
  Widget build(BuildContext context, ref) {


    int count = ref.watch(pageProvider);
    List<BarGraphModel>? barGraphData = count == 0 ?
    ref.watch(transactionProvider).UserBarGraph: count == 1 ?
    ref.watch(transactionProvider).TransactionBarGraph: count == 2 ?
    ref.watch(transactionProvider).EscrowBarGraph: count == 3 ?
    ref.watch(transactionProvider).CardBarGraph: count == 4 ?
    ref.watch(transactionProvider).PaymentBarGraph: count == 5 ?
    ref.watch(transactionProvider).PaybillBarGraph :
    ref.watch(transactionProvider).NearMeBarGraph
    ;
    count == 5 ?
    print(ref.watch(transactionProvider).PaybillBarGraph.toString()):print('transaction');

    return GridView.builder(
      itemCount: barGraphData.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 12.0,
        childAspectRatio: 5 / 4,
      ),
      itemBuilder: (context, index) {
        return CustomCard(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  barGraphData[index].label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BarChart(
                  BarChartData(
                    barGroups: _chartGroups(
                      points: barGraphData[index].graph,
                      color: barGraphData[index].color,
                    ),
                    borderData: FlBorderData(border: const Border()),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                barGraphData[index].graphLabels[value.toInt()],
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _chartGroups(
      {required List<GraphModel> points, required Color color}) {
    return points
        .map((point) => BarChartGroupData(x: point.x.toInt(), barRods: [
              BarChartRodData(
                toY: point.y,
                width: 12,
                color: color.withOpacity(point.y.toInt() > 4 ? 1 : 0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3.0),
                  topRight: Radius.circular(3.0),
                ),
              )
            ]))
        .toList();
  }
}
