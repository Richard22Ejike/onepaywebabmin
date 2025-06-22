
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepluspay/features/Transactions/presentation/providers/transactions_provider.dart';
import 'package:onepluspay/test/data/line_chart_data.dart';
import 'package:onepluspay/test/widgets/custom_card_widget.dart';

import '../const/constant.dart';

class LineChartCard extends ConsumerWidget {
  const LineChartCard({super.key});

  @override
  Widget build(BuildContext context, ref) {

    int count = ref.watch(pageProvider);
    MonthlyLineData? data = count == 0 ?
    ref.watch(transactionProvider).UserLinechat: count == 1 ?
    ref.watch(transactionProvider).TransactionLineChart: count == 2 ?
    ref.watch(transactionProvider).EscrowLineChart: count == 3 ?
    ref.watch(transactionProvider).CardLineChart: count == 4 ?
    ref.watch(transactionProvider).PaybillLineChart: count == 5 ?
    ref.watch(transactionProvider).monthlyPaymentData :
    ref.watch(transactionProvider).NearMeLineChart
    ;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SIgn Ups Overview",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 16 / 6,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: cardBackgroundColor.withOpacity(0.8), // set your custom color here
                  ),
                ),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data!.bottomTitle[value.toInt()] != null
                            ? SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                    data.bottomTitle[value.toInt()].toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[400])),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data!.leftTitle[value.toInt()] != null
                            ? Text(data.leftTitle[value.toInt()].toString(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[400]))
                            : const SizedBox();
                      },
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    color: selectionColor,
                    barWidth: 2.5,

                    belowBarData: BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          selectionColor.withOpacity(0.9),
                          Colors.transparent
                        ],
                      ),
                      show: true,
                    ),
                    aboveBarData:  BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          selectionColor.withOpacity(0.5),
                          Colors.transparent
                        ],
                      ),
                      show: true,
                    ),
                    dotData: FlDotData(show: false),
                    spots: data!.spots,

                  )
                ],
                backgroundColor: cardBackgroundColor,

                minX: 0,
                maxX: 120,
                maxY: 105,
                minY: -5,

              ),
            ),
          ),
        ],
      ),
    );
  }
}
