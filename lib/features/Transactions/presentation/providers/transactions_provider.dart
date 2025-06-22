import 'dart:developer';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onepluspay/features/card/business/entities/card_entity.dart';
import 'package:onepluspay/features/card/business/entities/payment_link_entity.dart';
import 'package:onepluspay/features/paybills/business/entities/entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/utils.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../../core/widgets/core/successful_screen.dart';
import '../../../../core/widgets/core/transaction_failed.dart';
import '../../../../test/model/bar_graph_model.dart';
import '../../../../test/model/graph_model.dart';
import '../../../Auth/business/entities/entity.dart';
import '../../../Auth/data/models/User_model.dart';
import '../../../Auth/presentation/providers/User_provider.dart';
import '../../../Escrow/business/entities/entity.dart';
import '../../../NearMe/business/entities/entity.dart';
import '../../business/entities/entity.dart';
import '../../business/usecases/transaction_usecases.dart';
import '../../data/datasources/transaction_local_data_source.dart';
import '../../data/datasources/transaction_remote_data_source.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import 'package:http/http.dart' as http;



final transactionProvider = ChangeNotifierProvider((ref) => TransactionProvider());
final searchProvider = StateProvider<String>((ref) => '');
final pageProvider = StateProvider<int>((ref) => 0);
Color getRandomColor(String seed) {
  // Create a consistent color based on the seed string
  final hash = seed.hashCode;
  return Color(hash & 0xFFFFFF).withOpacity(1.0);
}

class TransactionProvider extends ChangeNotifier {
  List<TransactionEntity>? transactions ;
  List<EscrowEntity>? Escrows ;
  List<CardEntity>? Card;
  List<PayBillsEntity>? Paybills;
  List<PaymentLinkEntity>? Paymentlinks ;
  List<NearMeEntity>? NearMeList ;
  List<BankEntity> banks = [];

  TransactionEntity? transaction;
  List<UserEntity>? user;

  Failure? failure;
  ChartData? escrowInfo;
  String? accountName;
  String? bank;
  late TransactionParams transactionParams;
  //USER
  List<BarGraphModel> UserBarGraph = [];
  List<ChartData>UserSummarires = [];
  MonthlyLineData? UserLinechat;
  List <PieChartSectionData>? UserPieChart;
  List<UserEntity> lastThreeUsers = [];

  //ESCROW
  List<EscrowEntity>? lastThreeEscrows;
  List<BarGraphModel> EscrowBarGraph = [];
  List<PieChartSectionData> EscrowPieChart = [];
  MonthlyLineData? EscrowLineChart;
  List<ChartData> EscrowSummaries = [];

  //TRANSACTIONS
  List<TransactionEntity>? lastThreeTransactions;
  List<BarGraphModel> TransactionBarGraph = [];
  List<PieChartSectionData> TransactionPieChart = [];
  MonthlyLineData? TransactionLineChart;
  List<ChartData> TransactionSummaries = [];

  //PAYMENTLINK
  List<PaymentDetailEntity>? lastThreePayments;
  List<BarGraphModel> PaymentBarGraph = [];
  List<PieChartSectionData> paymentTypePie = [];
  MonthlyLineData? monthlyPaymentData;
  List<ChartData> PaymentSummaries = [];

  //CARDS
  List<CardEntity>? lastThreeCards;
  List<BarGraphModel> CardBarGraph = [];
  List<PieChartSectionData> CardPieChart = [];
  MonthlyLineData? CardLineChart;
  List<ChartData> CardSummaries = [];

  //PAYBILLS
  List<PayBillsEntity>? lastThreePaybill;
  List<BarGraphModel> PaybillBarGraph = [];
  List<PieChartSectionData> PaybillPieChart = [];
  MonthlyLineData? PaybillLineChart;
  List<ChartData> PaybillSummaries = [];

  //NearMe
  List<NearMeEntity>? lastThreeNearMe;
  List<BarGraphModel> NearMeBarGraph = [];
  List<PieChartSectionData> NearMePieChart = [];
  MonthlyLineData? NearMeLineChart;
  List<ChartData> NearMeSummaries = [];
  TransactionProvider({


    this.transaction,
    this.user,
    this.failure,
    this.accountName,

    this.bank,
    TransactionParams? initialParams,
  }) {

    transactionParams = initialParams ?? TransactionParams();
  }
  void updateTransactionParams(TransactionParams newTransactionParams) {
    transactionParams = newTransactionParams;
    notifyListeners();
  }
  void updateDropdownValue(String newValue) {
    bank = newValue;
    notifyListeners();
  }
  void updateTransactionPin({required String pin, }) {
    transactionParams.pin = pin;

    notifyListeners();
  }

    void eitherFailureOrTransactions(BuildContext context, WidgetRef ref, String CustomerId) async {
    TransactionRepositoryImpl repository = TransactionRepositoryImpl(
      remoteDataSource: TransactionRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: TransactionLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrTransaction = await Transactions(transactionRepository: repository).call(
      transactionParams: TransactionParams(
        customerId: CustomerId,
        token:token
      ),
    );

      transactions = failureOrTransaction.$2!;
      failure = failureOrTransaction.$1;
      notifyListeners();
      if(transactions != null){
        List<TransactionEntity> sortedTransactions = List.from(transactions!)
          ..sort((a, b) => b.dateSent.compareTo(a.dateSent));
        lastThreeTransactions = sortedTransactions.take(3).toList();

        Map<String, int> monthlyTransactions = {};
        DateTime now = DateTime.now();
        for (int i = 0; i < 12; i++) {
          DateTime month = DateTime(now.year, now.month - (11 - i), 1);
          String label = DateFormat('MMM').format(month);
          monthlyTransactions[label] = 0;
        }

        for (var tx in transactions!) {
          if (tx.dateSent.isAfter(DateTime(now.year - 1, now.month, now.day))) {
            String label = DateFormat('MMM').format(tx.dateSent);
            monthlyTransactions[label] = (monthlyTransactions[label] ?? 0) + 1;
          }
        }

        List<FlSpot> transactionSpots = [];
        Map<double, String> transactionBottomTitle = {};
        int index = 0;
        monthlyTransactions.forEach((label, count) {
          double x = index * 10.0;
          transactionSpots.add(FlSpot(x, count.toDouble()));
          transactionBottomTitle[x] = label;
          index++;
        });

        TransactionLineChart = MonthlyLineData(
          spots: transactionSpots,
          bottomTitle: transactionBottomTitle,
          leftTitle: {
            0: '0',
            10: '10',
            20: '20',
            30: '30',
            40: '40',
            50: '50',
            60: '60',
            70: '70',
            80: '80',
            90: '90',
            100: '100',
          },
        );


        int creditCount = transactions!.where((t) => t.credit).length;
        int debitCount = transactions!.length - creditCount;

        TransactionPieChart = [
          PieChartSectionData(
            color: Colors.green,
            value: creditCount.toDouble(),
            title: 'credit ${((creditCount / transactions!.length) * 100).toStringAsFixed(1)}%',
            radius: 20,
            titleStyle: TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            color: Colors.red,
            value: debitCount.toDouble(),
            title: ' debit ${((debitCount / transactions!.length) * 100).toStringAsFixed(1)}%',
            radius: 30,
            titleStyle: TextStyle(color: Colors.white),
          ),
        ];


        log(transactions![0].toString());
        int inRange(double lower, double upper) => transactions!
            .where((t) => t.amount >= lower && t.amount <= upper)
            .length;

        TransactionBarGraph = [BarGraphModel(
          label: "Amount Range",
          color: Colors.purple,
          graph: [
            GraphModel(x: 0, y: inRange(0, 1000).toDouble()),
            GraphModel(x: 1, y: inRange(1001, 10000).toDouble()),
            GraphModel(x: 2, y: inRange(10001, 100000).toDouble()),
            GraphModel(x: 3, y: transactions!
                .where((t) => t.amount > 100000).length.toDouble()),
          ],
          graphLabels: ['0-1k', '1k-10k', '10k-100k', '100k+'],
        )];


        double totalAmount = transactions!.fold(0.0, (sum, tx) => sum + tx.amount);
        double averageAmount = totalAmount / transactions!.length;

        List<TransactionEntity> sortedByAmount = List.from(transactions!)
          ..sort((a, b) => a.amount.compareTo(b.amount));
        int medianIndex = sortedByAmount.length ~/ 2;
        double medianAmount = sortedByAmount[medianIndex].amount.toDouble();
        double highest = sortedByAmount.last.amount.toDouble();

        TransactionSummaries =[
          ChartData(label: "Total Amount", count: totalAmount),
          ChartData(label: "Average Amount", count: averageAmount),
          ChartData(label: "Median Amount", count: medianAmount),
          ChartData(label: "Highest Amount", count: highest),
        ];

        }
       else {
        log('null transactions');
      }
    ref
        .watch(isLoader.notifier)
        .state = false;

  }
    void eitherFailureOrGetUsers(BuildContext context, WidgetRef ref) async {
    ref.watch(isLoader.notifier).state = true;

    TransactionRepositoryImpl repository = TransactionRepositoryImpl(
      remoteDataSource: TransactionRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: TransactionLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrTransaction = await Transactions(
        transactionRepository: repository).getUsers(
      transactionParams: TransactionParams(
          accountNumber: transactionParams.accountNumber,
          token: token
      ),
    );


    user = failureOrTransaction.$2;

    failure = failureOrTransaction.$1;
    if (user != null) {

      if (user != null && user!.isNotEmpty) {
        List<UserEntity> sortedBySignUp = List.from(user!)
          ..sort((a, b) => DateTime.parse(b.created).compareTo(DateTime.parse(a.created)));
        lastThreeUsers = sortedBySignUp.take(3).toList();


        // 1. Compute Monthly User Growth for the past 12 months:
        DateTime now = DateTime.now();
        DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);
        // Initialize a map for the past 12 months using month labels.
        Map<String, int> monthlyGrowth = {};
        for (int i = 0; i < 12; i++) {
          // Calculate month in order from 11 months ago up to current month.
          DateTime monthDate = DateTime(now.year, now.month - (11 - i), 1);
          String label = DateFormat('MMM').format(monthDate);
          monthlyGrowth[label] = 0;
        }
        // Count users created in the past year, grouped by month.
        for (var user in user!) {
          DateTime createdDate = DateTime.tryParse(user.created) ?? now;
          if (createdDate.isAfter(oneYearAgo)) {
            String label = DateFormat('MMM').format(createdDate);
            monthlyGrowth[label] = (monthlyGrowth[label] ?? 0) + 1;
          }
        }
        // Convert monthlyGrowth map into a list of ChartData:
        List<ChartData> monthlyGrowthData = [];
        monthlyGrowth.forEach((label, count) {
          monthlyGrowthData.add(ChartData(label: label, count: count.toDouble()));
        });
        // Sort by month order if needed:
        monthlyGrowthData.sort((a, b) {
          int aMonth = DateFormat('MMM').parse(a.label).month;
          int bMonth = DateFormat('MMM').parse(b.label).month;
          return aMonth.compareTo(bMonth);
        });

        // Map monthlyGrowthData to chart spots and bottom titles.
        // Here we set x-axis values as index * 10 (adjust as needed).
        List<FlSpot> growthSpots = [];
        Map<double, String> growthBottomTitle = {};
        for (int i = 0; i < monthlyGrowthData.length; i++) {
          double x = i * 10.0;
          growthSpots.add(FlSpot(x, monthlyGrowthData[i].count.toDouble()));
          growthBottomTitle[x] = monthlyGrowthData[i].label;
        }

        // Define left titles (adjust as needed for your scale).
        Map<double, String> growthLeftTitle = {
          0: '0',
          10: '10',
          20: '20',
          30: '30',
          40: '40',
          50: '50',
          60: '60',
          70: '70',
          80: '80',
          90: '90',
          100: '100',
        };

        // Now create a MonthlyLineData instance
        UserLinechat = MonthlyLineData(
          spots: growthSpots,
          bottomTitle: growthBottomTitle,
          leftTitle: growthLeftTitle,
        );
      }


       final usersWithEscrow = user!.where((user) => user.escrow_fund > 0).length;
       final usersWithoutEscrow = user!.length - usersWithEscrow;

       // Create pie chart sections
       UserPieChart = [
         PieChartSectionData(
           color: Colors.green, // Color for users with escrow
           value: usersWithEscrow.toDouble(),
           title: 'Escrow ${((usersWithEscrow/user!.length)*100).toStringAsFixed(1)}%',
           radius: 20,
           titleStyle: TextStyle(
             fontSize: 12,
             fontWeight: FontWeight.bold,
             color: Colors.white,
           ),
         ),
         PieChartSectionData(
           color: Colors.blue, // Color for users without escrow
           value: usersWithoutEscrow.toDouble(),
           title: ' No Escrow ${((usersWithoutEscrow/user!.length)*100).toStringAsFixed(1)}%',
           radius: 30,
           titleStyle: TextStyle(
             fontSize: 12,
             fontWeight: FontWeight.bold,
             color: Colors.white,
           ),
         ),
       ];

       // Add to your existing chart data structure
       escrowInfo = ChartData(
         label: usersWithoutEscrow.toString(),
         count: usersWithEscrow.toDouble(),

       );




      final verifiedCount = user!
            .where((user) => user.isVerified)
            .length;
        final unverifiedCount = user!.length - verifiedCount;
        UserBarGraph.add(BarGraphModel(
          label: "Verified vs Unverified",
          color: const Color(0xFFFEB95A), // Adjust color as needed
          graph: [
            GraphModel(x: 0, y: verifiedCount.toDouble()),
            GraphModel(x: 1, y: unverifiedCount.toDouble()),
          ], graphLabels: ['Ver', 'UnVer'],
        ));


// Example function for KYC Tier Distribution:



// Example function for Balance Distribution:

        int countInRange(double lower, double upper) =>
            user!
                .where((user) => user.balance >= lower && user.balance <= upper)
                .length;

        final List<GraphModel> graph1s = [
          GraphModel(x: 0, y: countInRange(0, 1000).toDouble()),
          GraphModel(x: 1, y: countInRange(1001, 10000).toDouble()),
          GraphModel(x: 2, y: countInRange(10001, 100000).toDouble()),
          GraphModel(x: 3, y: user!
              .where((user) => user.balance > 1000)
              .length
              .toDouble()),
        ];

      UserBarGraph.add(BarGraphModel(
          label: "Balance Distribution",
          color: const Color(0xFF20AEF3), // Adjust color as needed
          graph: graph1s,
         graphLabels: ['0-1k', '1k-10k', '10k-100k', '1000>'],
        ));


// Example function for Active vs Inactive users:

        final activeCount = user!
            .where((user) => user.isActive)
            .length;
        final inactiveCount = user!.length - activeCount;
      UserBarGraph.add(BarGraphModel(
          label: "Active vs Inactive",

          color: const Color(0xFF88B2AC), // Adjust color as needed
          graph: [
            GraphModel(x: 0, y: activeCount.toDouble()),
            GraphModel(x: 1, y: inactiveCount.toDouble()),
          ], graphLabels: ['active', 'inactive'],
        ));

      List<UserEntity> users = user!.map((model) => model).toList();


      double highestBalance= users.reduce((curr, next) =>
        curr.balance > next.balance ? curr : next).balance;
        double totalBalance = user!.fold(
            0.0, (prev, element) => prev + element.balance);
        double averageBalance = user!.isNotEmpty
            ? totalBalance / user!.length
            : 0.0;
        List<UserEntity> sortedUsers = List.from(user!)..sort((a, b) => a.balance.compareTo(b.balance));
        int medianIndex = sortedUsers.length ~/ 2;
        UserEntity medianBalanceUser = sortedUsers[medianIndex];
        UserSummarires = [
          ChartData(label: "Highest Balance",
            count: highestBalance),
        ChartData(label: "Median Balance",
            count: medianBalanceUser.balance),
          ChartData(label: "Average Balance",
              count: averageBalance)
        ];
      }
      notifyListeners();
      ref
          .watch(isLoader.notifier)
          .state = false;

    }
    void eitherFailureOrEscrows(BuildContext context, WidgetRef ref, String CustomerId) async {
    ref.watch(isLoader.notifier).state = true;

    TransactionRepositoryImpl repository = TransactionRepositoryImpl(
      remoteDataSource: TransactionRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: TransactionLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrTransaction = await Transactions(
        transactionRepository: repository
    ).escrows(
      transactionParams: TransactionParams(
          customerId: CustomerId,
          token: token
      ),
    );

    Escrows = failureOrTransaction.$2!;
    failure = failureOrTransaction.$1;
    if(Escrows != null){
      if (Escrows != null && Escrows!.isNotEmpty) {
        // 1. Get last 3 escrows (similar to users)
        List<EscrowEntity> sortedByCreated = List.from(Escrows!)
          ..sort((a, b) => b.created_at.compareTo(a.created_at));
        lastThreeEscrows = sortedByCreated.take(3).toList();

        // 2. Monthly Escrow Growth (similar to users)
        DateTime now = DateTime.now();
        DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);
        Map<String, int> monthlyEscrowGrowth = {};

        for (int i = 0; i < 12; i++) {
          DateTime monthDate = DateTime(now.year, now.month - (11 - i), 1);
          String label = DateFormat('MMM').format(monthDate);
          monthlyEscrowGrowth[label] = 0;
        }

        for (var escrow in Escrows!) {
          if (escrow.created_at.isAfter(oneYearAgo)) {
            String label = DateFormat('MMM').format(escrow.created_at);
            monthlyEscrowGrowth[label] = (monthlyEscrowGrowth[label] ?? 0) + 1;
          }
        }

        // Convert to chart data
        List<ChartData> monthlyEscrowGrowthData = [];
        monthlyEscrowGrowth.forEach((label, count) {
          monthlyEscrowGrowthData.add(ChartData(label: label, count: count.toDouble()));
        });

        monthlyEscrowGrowthData.sort((a, b) {
          int aMonth = DateFormat('MMM').parse(a.label).month;
          int bMonth = DateFormat('MMM').parse(b.label).month;
          return aMonth.compareTo(bMonth);
        });

        // Create line chart data
        List<FlSpot> escrowGrowthSpots = [];
        Map<double, String> escrowBottomTitle = {};

        for (int i = 0; i < monthlyEscrowGrowthData.length; i++) {
          double x = i * 10.0;
          escrowGrowthSpots.add(FlSpot(x, monthlyEscrowGrowthData[i].count.toDouble()));
          escrowBottomTitle[x] = monthlyEscrowGrowthData[i].label;
        }

        EscrowLineChart = MonthlyLineData(
          spots: escrowGrowthSpots,
          bottomTitle: escrowBottomTitle,
          leftTitle: {
            0: '0',
            10: '10',
            20: '20',
            30: '30',
            40: '40',
            50: '50',
            60: '60',
            70: '70',
            80: '80',
            90: '90',
            100: '100',
          },
        );

        // 3. Escrow Status Distribution (similar to verified users)
        final activeEscrows = Escrows!.where((e) => e.escrow_Status == 'active').length;
        final completedEscrows = Escrows!.where((e) => e.escrow_Status == 'completed').length;
        final pendingEscrows = Escrows!.length - activeEscrows - completedEscrows;

        EscrowBarGraph = [BarGraphModel(
          label: "Escrow Status",
          color: const Color(0xFFFEB95A),
          graph: [
            GraphModel(x: 0, y: activeEscrows.toDouble()),
            GraphModel(x: 1, y: completedEscrows.toDouble()),
            GraphModel(x: 2, y: pendingEscrows.toDouble()),
          ],
          graphLabels: ['Active', 'Completed', 'Pending'],
        )];

        // 4. Escrow Amount Distribution (similar to balance distribution)
        int escrowCountInRange(double lower, double upper) =>
            Escrows!.where((e) => e.amount >= lower && e.amount <= upper).length;

        final List<GraphModel> escrowAmountGraph = [
          GraphModel(x: 0, y: escrowCountInRange(0, 1000).toDouble()),
          GraphModel(x: 1, y: escrowCountInRange(1001, 10000).toDouble()),
          GraphModel(x: 2, y: escrowCountInRange(10001, 100000).toDouble()),
          GraphModel(x: 3, y: escrowCountInRange(100001, double.infinity).toDouble()),
        ];

        EscrowBarGraph = [BarGraphModel(
          label: "Escrow Amounts",
          color: const Color(0xFF20AEF3),
          graph: escrowAmountGraph,
          graphLabels: ['0-1k', '1k-10k', '10k-100k', '100k+'],
        )];

        // 5. Payment Type Distribution (pie chart)
        final bankTransfers = Escrows!.where((e) => e.payment_type == '0ne-time').length;
        final cardPayments = Escrows!.where((e) => e.payment_type == 'Continuous').length;
        final otherPayments = Escrows!.length - bankTransfers - cardPayments;

        EscrowPieChart = [
          PieChartSectionData(
            color: Colors.blue,
            value: bankTransfers.toDouble(),
            title: 'Bank ${((bankTransfers/Escrows!.length)*100).toStringAsFixed(1)}%',
            radius: 30,
          ),
          PieChartSectionData(
            color: Colors.green,
            value: cardPayments.toDouble(),
            title: 'Card ${((cardPayments/Escrows!.length)*100).toStringAsFixed(1)}%',
            radius: 30,
          ),
          PieChartSectionData(
            color: Colors.orange,
            value: otherPayments.toDouble(),
            title: 'Other ${((otherPayments/Escrows!.length)*100).toStringAsFixed(1)}%',
            radius: 30,
          ),
        ];

        // 6. Summary statistics (similar to user balances)

        final List<EscrowEntity> entityList = Escrows!.cast<EscrowEntity>();
        double highestAmount =
            entityList.reduce((curr, next) =>
            curr.amount > next.amount ? curr : next).amount.toDouble();


        double totalAmount = entityList.fold(0.0, (prev, e) => prev + e.amount.toDouble());
        double averageAmount = entityList.isNotEmpty ? totalAmount / entityList.length : 0.0;

        List<EscrowEntity> sortedByAmount = List.from(Escrows!)..sort((a, b) => a.amount.compareTo(b.amount));
        double medianAmount = sortedByAmount.isNotEmpty
            ? sortedByAmount[sortedByAmount.length ~/ 2].amount.toDouble()
            : 0.0;


          EscrowSummaries = [
          ChartData(label: "Highest Escrow", count: highestAmount),
          ChartData(label: "Median Escrow", count: medianAmount),
          ChartData(label: "Average Escrow", count: averageAmount),
          ChartData(label: "Total Escrows", count: Escrows!.length.toDouble()),
        ];
      }
    }


    notifyListeners();
    ref.watch(isLoader.notifier).state = false;
  }
    void eitherFailureOrPaymentLinks(BuildContext context,
        WidgetRef ref) async {
      ref
          .watch(isLoader.notifier)
          .state = true;
      TransactionRepositoryImpl repository = TransactionRepositoryImpl(
        remoteDataSource: TransactionRemoteDataSourceImpl(
          httpClient: http.Client(),
        ),
        localDataSource: TransactionLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance(),
        ),

      );
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final failureOrTransaction = await Transactions(
          transactionRepository: repository).paymentlinks(
        transactionParams: TransactionParams(
            accountNumber: transactionParams.accountNumber,
            token: token
        ),
      );


      Paymentlinks = failureOrTransaction.$2!;
      failure = failureOrTransaction.$1;
      if (Paymentlinks != null) {
        print('Payment link: $Paymentlinks');

        List<PaymentDetailEntity> allDetails = Paymentlinks!
            .expand((link) => link.payment_details)
            .toList();

        if (allDetails.isEmpty) {
          // Default logic for when no payment details are available

          // Default last three payments (can be mock or empty)
          lastThreePayments = [];

          // Create dummy chart data with 12 months, all zeroes
          List<ChartData> defaultChartData = List.generate(12, (index) {
            String label = DateFormat('MMM').format(
              DateTime(DateTime.now().year, DateTime.now().month - (11 - index)),
            );
            return ChartData(label: label, count: 0);
          });

          List<FlSpot> paymentSpots = [];
          Map<double, String> bottomTitles = {};

          for (int i = 0; i < defaultChartData.length; i++) {
            double x = i * 10;
            paymentSpots.add(FlSpot(x, 0));
            bottomTitles[x] = defaultChartData[i].label;
          }

          monthlyPaymentData = MonthlyLineData(
            spots: paymentSpots,
            bottomTitle: bottomTitles,
            leftTitle: {
              0: '0',
              10: '10',
              20: '20',
              30: '30',
              40: '40',
              50: '50',
              60: '60',
              70: '70',
              80: '80',
              90: '90',
              100: '100',
            },
          );

          paymentTypePie = [];

          PaymentBarGraph = [
            BarGraphModel(
              label: "Amount Distribution",
              color: Color(0xFF66BB6A),
              graph: [
                GraphModel(x: 0, y: 0),
                GraphModel(x: 1, y: 0),
                GraphModel(x: 2, y: 0),
                GraphModel(x: 3, y: 0),
              ],
              graphLabels: ['0-1k', '1k-10k', '10k-100k', '>100k'],
            ),
          ];

          PaymentSummaries = [
            ChartData(label: "Highest Amount", count: 0),
            ChartData(label: "Median Amount", count: 0),
            ChartData(label: "Average Amount", count: 0),
          ];

          notifyListeners();
          ref.watch(isLoader.notifier).state = false;
          return;
        }

        // 🔽 Existing logic continues below if allDetails is not empty...
        // [Insert your current detailed processing logic here]
      }

      notifyListeners();
      ref
          .watch(isLoader.notifier)
          .state = false;
    }
    void eitherFailureOrCards(BuildContext context, WidgetRef ref,
        String CustomerId) async {
      TransactionRepositoryImpl repository = TransactionRepositoryImpl(
        remoteDataSource: TransactionRemoteDataSourceImpl(
          httpClient: http.Client(),
        ),
        localDataSource: TransactionLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance(),
        ),

      );
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final failureOrTransaction = await Transactions(
          transactionRepository: repository).cards(
        transactionParams: TransactionParams(
            customerId: CustomerId,
            token: token
        ),
      );

      Card = failureOrTransaction.$2!;
      failure = failureOrTransaction.$1;
      notifyListeners();
      if (Card != null) {
        List<CardEntity> sortedByCreated = List.from(Card!)..sort(
              (a, b) => b.dateCreated.compareTo(a.dateCreated),
        );
        lastThreeCards = sortedByCreated.take(3).toList(); // You can define this list

        DateTime now = DateTime.now();
        DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);
        Map<String, int> monthlyCardGrowth = {};

        for (int i = 0; i < 12; i++) {
          DateTime monthDate = DateTime(now.year, now.month - (11 - i), 1);
          String label = DateFormat('MMM').format(monthDate);
          monthlyCardGrowth[label] = 0;
        }

        for (var card in Card!) {
          if (card.dateCreated.isAfter(oneYearAgo)) {
            String label = DateFormat('MMM').format(card.dateCreated);
            monthlyCardGrowth[label] = (monthlyCardGrowth[label] ?? 0) + 1;
          }
        }

        List<ChartData> monthlyCardData = monthlyCardGrowth.entries
            .map((e) => ChartData(label: e.key, count: e.value.toDouble()))
            .toList();

// Convert to FlSpot and titles
        List<FlSpot> cardSpots = [];
        Map<double, String> cardBottomTitles = {};
        for (int i = 0; i < monthlyCardData.length; i++) {
          double x = i * 10.0;
          cardSpots.add(FlSpot(x, monthlyCardData[i].count));
          cardBottomTitles[x] = monthlyCardData[i].label;
        }

        CardLineChart = MonthlyLineData(
          spots: cardSpots,
          bottomTitle: cardBottomTitles,
          leftTitle: {
            0: '0',
            10: '10',
            20: '20',
            30: '30',
            40: '40',
            50: '50',
            60: '60',
            70: '70',
            80: '80',
            90: '90',
            100: '100',
          },
        );
        int cardsInRange(double lower, double upper) =>
            Card!.where((card) => card.balance >= lower && card.balance <= upper).length;

        List<GraphModel> balanceDistribution = [
          GraphModel(x: 0, y: cardsInRange(0, 1000).toDouble()),
          GraphModel(x: 1, y: cardsInRange(1001, 10000).toDouble()),
          GraphModel(x: 2, y: cardsInRange(10001, 100000).toDouble()),
          GraphModel(x: 3, y: Card!.where((c) => c.balance > 100000).length.toDouble()),
       ];

        CardBarGraph = [BarGraphModel(
          label: "Card Balance Distribution",
          color: Colors.teal,
          graph: balanceDistribution,
          graphLabels: ['0-1k', '1k-10k', '10k-100k', '100k+'],
        )];
        Map<String, int> brandCounts = {};
        for (var card in Card!) {
          brandCounts[card.brand] = (brandCounts[card.brand] ?? 0) + 1;
        }

        CardPieChart = brandCounts.entries.map((entry) {
          return PieChartSectionData(
            color: getRandomColor(entry.key), // Define this function
            value: entry.value.toDouble(),
            title: '${entry.key} ${(entry.value / Card!.length * 100).toStringAsFixed(1)}%',
            radius: 25,
            titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList();
        final List<CardEntity> entityList = Card!.cast<CardEntity>();
        double highestCardBalance = entityList.reduce((a, b) => a.balance > b.balance ? a : b).balance;
        double totalCardBalance = entityList.fold(0.0, (sum, c) => sum + c.balance);
        double averageCardBalance = entityList.isNotEmpty ? totalCardBalance / Card!.length : 0.0;

        List<CardEntity> sortedCards = List.from(Card!)..sort((a, b) => a.balance.compareTo(b.balance));
        double medianBalance = sortedCards[Card!.length ~/ 2].balance;

        CardSummaries = [
          ChartData(label: "Highest Balance", count: highestCardBalance),
          ChartData(label: "Median Balance", count: medianBalance),
          ChartData(label: "Average Balance", count: averageCardBalance),
        ];


      } else {
        log('null transactions');
      }
      ref
          .watch(isLoader.notifier)
          .state = false;
    }

  void eitherFailureOrNearMe(BuildContext context, WidgetRef ref, String customerId) async {
    TransactionRepositoryImpl repository = TransactionRepositoryImpl(
      remoteDataSource: TransactionRemoteDataSourceImpl(httpClient: http.Client()),
      localDataSource: TransactionLocalDataSourceImpl(sharedPreferences: await SharedPreferences.getInstance()),

    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final failureOrNearMe = await Transactions(transactionRepository: repository).nearmes(
     transactionParams:  TransactionParams(customerId: customerId, token: token),
    );

    NearMeList = failureOrNearMe.$2!;
    failure = failureOrNearMe.$1;
    notifyListeners();

    if (NearMeList != null) {
      List<NearMeEntity> sortedByCreated = List.from(NearMeList!)..sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
      );
      lastThreeNearMe = sortedByCreated.take(3).toList();

      DateTime now = DateTime.now();
      DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);
      Map<String, int> monthlyProductGrowth = {};

      for (int i = 0; i < 12; i++) {
        DateTime monthDate = DateTime(now.year, now.month - (11 - i), 1);
        String label = DateFormat('MMM').format(monthDate);
        monthlyProductGrowth[label] = 0;
      }

      for (var product in NearMeList!) {
        if (product.createdAt.isAfter(oneYearAgo)) {
          String label = DateFormat('MMM').format(product.createdAt);
          monthlyProductGrowth[label] = (monthlyProductGrowth[label] ?? 0) + 1;
        }
      }

      List<ChartData> monthlyProductData = monthlyProductGrowth.entries
          .map((e) => ChartData(label: e.key, count: e.value.toDouble()))
          .toList();

      List<FlSpot> productSpots = [];
      Map<double, String> bottomTitles = {};
      for (int i = 0; i < monthlyProductData.length; i++) {
        double x = i * 10.0;
        productSpots.add(FlSpot(x, monthlyProductData[i].count));
        bottomTitles[x] = monthlyProductData[i].label;
      }

      NearMeLineChart = MonthlyLineData(
        spots: productSpots,
        bottomTitle: bottomTitles,
        leftTitle: {for (int i = 0; i <= 100; i += 10) i.toDouble(): '$i'},
      );

      int itemsInPriceRange(double min, double max) =>
          NearMeList!.where((item) {
            final price = double.tryParse(item.price) ?? 0.0;
            return price >= min && price <= max;
          }).length;

      List<GraphModel> priceDistribution = [
        GraphModel(x: 0, y: itemsInPriceRange(0, 1000).toDouble()),
        GraphModel(x: 1, y: itemsInPriceRange(1001, 10000).toDouble()),
        GraphModel(x: 2, y: itemsInPriceRange(10001, 100000).toDouble()),
        GraphModel(x: 3, y: NearMeList!.where((item) => double.tryParse(item.price)! > 100000).length.toDouble()),
      ];

      NearMeBarGraph = [
        BarGraphModel(
          label: "Price Distribution",
          color: Colors.deepPurple,
          graph: priceDistribution,
          graphLabels: ['0-1k', '1k-10k', '10k-100k', '100k+'],
        ),
      ];

      Map<String, int> categoryCounts = {};
      for (var item in NearMeList!) {
        categoryCounts[item.productCategory] = (categoryCounts[item.productCategory] ?? 0) + 1;
      }

      NearMePieChart = categoryCounts.entries.map((entry) {
        return PieChartSectionData(
          color: getRandomColor(entry.key),
          value: entry.value.toDouble(),
          title: '${entry.key} ${(entry.value / NearMeList!.length * 100).toStringAsFixed(1)}%',
          radius: 25,
          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        );
      }).toList();

      List<double> prices = NearMeList!
          .map((e) => double.tryParse(e.price))
          .where((p) => p != null)
          .map((e) => e!)
          .toList();

      double highestPrice = prices.reduce((a, b) => a > b ? a : b);
      double totalPrice = prices.fold(0.0, (sum, price) => sum + price);
      double averagePrice = prices.isNotEmpty ? totalPrice / prices.length : 0.0;

      prices.sort();
      double medianPrice = prices.length.isOdd
          ? prices[prices.length ~/ 2]
          : (prices[(prices.length ~/ 2) - 1] + prices[prices.length ~/ 2]) / 2;

      NearMeSummaries = [
        ChartData(label: "Highest Price", count: highestPrice),
        ChartData(label: "Median Price", count: medianPrice),
        ChartData(label: "Average Price", count: averagePrice),
      ];
    } else {
      log('null NearMe data');
    }
    ref
        .watch(isLoader.notifier)
        .state = false;
  }

  void eitherFailureOrPaybills(BuildContext context, WidgetRef ref) async {
      ref
          .watch(isLoader.notifier)
          .state = true;
      TransactionRepositoryImpl repository = TransactionRepositoryImpl(
        remoteDataSource: TransactionRemoteDataSourceImpl(
          httpClient: http.Client(),
        ),
        localDataSource: TransactionLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance(),
        ),

      );
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final failureOrTransaction = await Transactions(
          transactionRepository: repository).paybills(
        transactionParams: TransactionParams(
            accountNumber: transactionParams.accountNumber,
            token: token
        ),
      );


      Paybills = failureOrTransaction.$2!;
      failure = failureOrTransaction.$1;
      if (Paybills != null) {
        print(Paybills!.first.status);
        print(Paybills!.last.status);
        List<PayBillsEntity> sortedByCreated = List.from(Paybills!)..sort(
              (a, b) => b.orderDate.compareTo(a.orderDate),
        );
        lastThreePaybill = sortedByCreated.take(3).toList();

        DateTime now = DateTime.now();
        DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);

        Map<String, int> monthlyBills = {};
        for (int i = 0; i < 12; i++) {
          DateTime monthDate = DateTime(now.year, now.month - (11 - i), 1);
          String label = DateFormat('MMM').format(monthDate);
          monthlyBills[label] = 0;
        }

        for (var bill in Paybills!) {
          if (bill.orderDate.isAfter(oneYearAgo)) {
            String label = DateFormat('MMM').format(bill.orderDate);
            monthlyBills[label] = (monthlyBills[label] ?? 0) + 1;
          }
        }

        List<ChartData> billGrowthData = [];
        monthlyBills.forEach((label, count) {
          billGrowthData.add(ChartData(label: label, count: count.toDouble()));
        });

        billGrowthData.sort((a, b) =>
            DateFormat('MMM').parse(a.label).month.compareTo(DateFormat('MMM').parse(b.label).month));

// Convert to FlSpots
        List<FlSpot> billSpots = [];
        Map<double, String> billBottomTitle = {};
        for (int i = 0; i < billGrowthData.length; i++) {
          double x = i * 10.0;
          billSpots.add(FlSpot(x, billGrowthData[i].count));
          billBottomTitle[x] = billGrowthData[i].label;
        }

        PaybillLineChart = MonthlyLineData(
          spots: billSpots,
          bottomTitle: billBottomTitle,
          leftTitle: {
            0: '0',
            10: '10',
            20: '20',
            30: '30',
            40: '40',
            50: '50',
            60: '60',
            70: '70',
            80: '80',
            90: '90',
            100: '100',
          },
        );

        Map<String, int> serviceTypeCount = {};
        for (var bill in Paybills!) {
          serviceTypeCount[bill.serviceType] = (serviceTypeCount[bill.serviceType] ?? 0) + 1;
        }

        List<PieChartSectionData> paybillPieSections = [];
        int totalBills = Paybills!.length;

        serviceTypeCount.forEach((type, count) {
          double percentage = (count / totalBills) * 100;
          paybillPieSections.add(
            PieChartSectionData(
              color: getRandomColor(count.toString()), // You can create a function for unique colors
              value: count.toDouble(),
              title: '${type} ${percentage.toStringAsFixed(1)}%',
              radius: 25,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          );
        });

        PaybillPieChart = paybillPieSections;

        int successCount = Paybills!.where((bill) => bill.status == 'ORDER_RECEIVED').length;
        int failedCount = Paybills!.length - successCount;
        print(successCount);
        print(failedCount);
        PaybillBarGraph = [
          BarGraphModel(
            label: "Success vs Failed",
            color: Colors.orange,
            graph: [
              GraphModel(x: 0, y: successCount.toDouble()),
              GraphModel(x: 1, y: failedCount.toDouble()),
            ],
            graphLabels: ['Success', 'Failed'],
          ),
        ];
        print(PaybillBarGraph);

        List<PayBillsEntity> sortedByAmount = List.from(Paybills!)..sort((a, b) => b.amount.compareTo(a.amount));
        double highestPay = sortedByAmount.first.amount;
        double totalPay = Paybills!.fold(0.0, (prev, curr) => prev + curr.amount);
        double averagePay = Paybills!.isNotEmpty ? totalPay / Paybills!.length : 0.0;
        double medianPay = sortedByAmount[Paybills!.length ~/ 2].amount;

        PaybillSummaries = [
          ChartData(label: "Highest Amount", count: highestPay),
          ChartData(label: "Median Amount", count: medianPay),
          ChartData(label: "Average Amount", count: averagePay),
        ];

      }
      notifyListeners();
      ref
          .watch(isLoader.notifier)
          .state = false;
    }
  }


class ChartData {
  final String label;
  final double count;

  ChartData({required this.label, required this.count});
}

class MonthlyLineData {
  final List<FlSpot> spots;
  final Map<double, String> leftTitle;
  final Map<double, String> bottomTitle;

  MonthlyLineData({
    required this.spots,
    required this.leftTitle,
    required this.bottomTitle,
  });
}