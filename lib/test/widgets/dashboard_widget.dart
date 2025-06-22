
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onepluspay/features/Auth/business/entities/entity.dart';
import 'package:onepluspay/features/Transactions/presentation/providers/transactions_provider.dart';
import 'package:onepluspay/test/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import '../../features/Escrow/business/entities/entity.dart';
import '../util/responsive.dart';
import 'activity_details_card.dart';
import 'bar_graph_widget.dart';
import 'header_widget.dart';
import 'line_chart_card.dart';

class DashboardWidget extends ConsumerWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int count = ref.watch(pageProvider);
    final views = [
      _TableView(),
      TransactionTableView(),
      _EscrowTableView(),
      CardTableView(),
      PayBillsTableView(),
      PaymentDetailsTableView(),
      NearMeDetailsTableView()
    ];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [

            const SizedBox(height: 18),
            const ActivityDetailsCard(),
            const SizedBox(height: 18),
            const LineChartCard(),
            const SizedBox(height: 18),
            const BarGraphCard(),
            const SizedBox(height: 18),
            if (Responsive.isTablet(context)) const SummaryWidget(),
            const SizedBox(height: 18),
            views[count]


          ],
        ),
      ),
    );
  }
}


class _TableView extends ConsumerStatefulWidget {
  const _TableView();

  @override
  ConsumerState<_TableView> createState() => _TableViewState();
}

class _TableViewState extends ConsumerState<_TableView> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<UserEntity>? users = ref.watch(transactionProvider).user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(color: theme.dividerColor),
      ),
      consumeSpanPadding: true
    );

    final searchQuery = ref.watch(searchProvider);
    // Handle case when users are null or empty
    final userList = users ?? [];
    final filteredUsers = (users ?? []).where((user) {
      if (searchQuery.isEmpty) return true;
      final query = searchQuery.toLowerCase();
      return user.firstName.toLowerCase().contains(query) ||
          user.lastName.toLowerCase().contains(query) ||
          user.accountNumber.toLowerCase().contains(query) ||
          user.phoneNumber.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();
    return


            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    if (!Responsive.isMobile(context))
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            ref.read(searchProvider.notifier).state = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                color: Colors.grey
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                    if (Responsive.isMobile(context))
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 25,
                            ),
                            onPressed: () {},
                          ),
                          InkWell(
                            onTap: () => Scaffold.of(context).openEndDrawer(),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                "assets/images/avatar.png",
                                width: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(
                  height: 350,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: filteredUsers.isEmpty
                        ? const Center(child: Text('No users available'))
                        : TableView.builder(
                      columnCount: 9, // Set appropriate number of columns for user data
                      rowCount: filteredUsers.length + 1, // +1 for header row
                      pinnedRowCount: 1,
                      pinnedColumnCount: 1,
                      columnBuilder: (index) {
                        return TableSpan(

                          foregroundDecoration: index == 0 ? decoration : null,
                          extent: const FractionalTableSpanExtent(1 / 7),
                        );
                      },
                      rowBuilder: (index) {
                        return TableSpan(
                          foregroundDecoration: index == 0 ? decoration : null,
                          extent: const FixedTableSpanExtent(100),

                        );
                      },
                      cellBuilder: (context, vicinity) {
                        final isStickyHeader = vicinity.xIndex == 0 || vicinity.yIndex == 0;
                        var label = '';
                        if (vicinity.yIndex == 0) {
                          // Header row
                          switch (vicinity.xIndex) {
                            case 0:
                              label = 'ID';
                            case 1:
                              label = 'Name';
                            case 2:
                              label = 'Email';
                            case 3:
                              label = 'Phone';
                            case 4:
                              label = 'Created';
                            case 5:
                              label = 'Account number';
                            case 6:
                              label = 'Balance';
                            case 7:
                              label = 'Escrow Fund';
                            case 8:
                              label = 'Status';
                            case 9:
                              label = 'Location';

                          }
                        } else {
                          // Data rows
                          final user =  filteredUsers[vicinity.yIndex - 1];
                          switch (vicinity.xIndex) {
                            case 0:
                              label = user.customerId.toString();
                            case 1:
                              label = '${user.firstName} ${user.lastName}';
                            case 2:
                              label = user.email;
                            case 3:
                              label = user.phoneNumber;
                            case 4:
                              label = formatStringDate(user.created);
                            case 5:
                              label = user.accountNumber ;
                            case 6:
                              label = user.formattedBalance;
                            case 7:
                              label = user.formattedEscrowFund;
                            case 8:
                              label = user.status ? 'Active' : 'Inactive';
                            case 9:
                              label = '${user.city}, ${user.state}, ${user.country}';
                          }
                        }
                        return TableViewCell(
                          child: ColoredBox(
                            color: isStickyHeader ? Colors.transparent : colorScheme.background,
                            child: Center(
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontWeight: isStickyHeader ? FontWeight.w600 : null,
                                      fontSize: 12,
                                      color: isStickyHeader ? null : colorScheme.outline,

                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),


                          ),
                ),
              ],
            );
  }

  String formatStringDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return formateddate(dateTime);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  // Your existing date formatter
  String formateddate(DateTime date) {
    return DateFormat('MMM. d | HH:mm').format(date);
  }
}
  // Helper method to format the date

class TransactionTableView extends ConsumerStatefulWidget {
  const TransactionTableView({super.key});

  @override
  ConsumerState<TransactionTableView> createState() => _TransactionTableViewState();
}

class _TransactionTableViewState extends ConsumerState<TransactionTableView> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider).transactions ?? [];
    final searchQuery = ref.watch(searchProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final decoration = TableSpanDecoration(
      border: TableSpanBorder(trailing: BorderSide(color: theme.dividerColor)),
      consumeSpanPadding: true,
    );

    final filteredTransactions = transactions.where((tx) {
      if (searchQuery.isEmpty) return true;
      final query = searchQuery.toLowerCase();
      return tx.name.toLowerCase().contains(query) ||
          tx.narration.toLowerCase().contains(query) ||
          tx.accountNumber.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        // Search Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!Responsive.isMobile(context))
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) =>
                  ref.read(searchProvider.notifier).state = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Search transaction',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            if (Responsive.isMobile(context))
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
          ],
        ),

        // Transaction Table
        SizedBox(
          height: 400,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: filteredTransactions.isEmpty
                ? const Center(child: Text("No transactions found"))
                : TableView.builder(
              columnCount: 8,
              rowCount: filteredTransactions.length + 1,
              pinnedRowCount: 1,
              pinnedColumnCount: 1,
              columnBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FractionalTableSpanExtent(1 / 6),
              ),
              rowBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FixedTableSpanExtent(90),
              ),
              cellBuilder: (context, vicinity) {
                final isHeader = vicinity.yIndex == 0;
                String label = '';

                if (isHeader) {
                  switch (vicinity.xIndex) {
                    case 0:
                      label = 'Name';
                    case 1:
                      label = 'Bank';
                    case 2:
                      label = 'Amount';
                    case 3:
                      label = 'Narration';
                    case 4:
                      label = 'Date';
                    case 5:
                      label = 'Account No';
                    case 6:
                      label = 'Account Balance';
                    case 7:
                      label = 'Credit';
                    case 8:
                      label = ' Sender Acc Number';
                  }
                } else {
                  final tx = filteredTransactions[vicinity.yIndex - 1];
                  switch (vicinity.xIndex) {
                    case 0:
                      label = tx.name;
                    case 1:
                      label = tx.bank;
                    case 2:
                      label = '${tx.currency} ${tx.amount}';
                    case 3:
                      label = tx.narration;
                    case 4:
                      label = _formatDate(tx.dateSent);
                    case 5:
                      label = tx.accountNumber;
                    case 6:
                      label = tx.formattedBalance;
                    case 7:
                      label = tx.credit.toString();
                    case 8:
                      label = tx.senderAccountNumber;
                  }
                }

                return TableViewCell(
                  child: ColoredBox(
                    color: isHeader ? Colors.transparent : colorScheme.background,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                            color: isHeader ? Colors.black : colorScheme.outline,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM. d, yyyy – HH:mm').format(date);
  }
}



class _EscrowTableView extends ConsumerStatefulWidget {
  const _EscrowTableView();

  @override
  ConsumerState<_EscrowTableView> createState() => _EscrowTableViewState();
}

class _EscrowTableViewState extends ConsumerState<_EscrowTableView> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<EscrowEntity>? escrows = ref.watch(transactionProvider).Escrows;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(color: theme.dividerColor),
      ),
      consumeSpanPadding: true,
    );

    final searchQuery = ref.watch(searchProvider);
    final filteredEscrows = (escrows ?? []).where((escrow) {
      if (searchQuery.isEmpty) return true;
      final query = searchQuery.toLowerCase();
      return escrow.escrowName.toLowerCase().contains(query) ||
          escrow.senderName.toLowerCase().contains(query) ||
          escrow.receiverEmail.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!Responsive.isMobile(context))
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    ref.read(searchProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 21),
                  ),
                ),
              ),
            if (Responsive.isMobile(context))
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey, size: 25),
                    onPressed: () {},
                  ),
                  InkWell(
                    onTap: () => Scaffold.of(context).openEndDrawer(),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset("assets/images/avatar.png", width: 32),
                    ),
                  ),
                ],
              ),
          ],
        ),
        SizedBox(
          height: 350,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: filteredEscrows.isEmpty
                ? const Center(child: Text('No escrows available'))
                : TableView.builder(
              columnCount: 6,
              rowCount: filteredEscrows.length + 1,
              pinnedRowCount: 1,
              pinnedColumnCount: 1,
              columnBuilder: (index) {
                return TableSpan(
                  foregroundDecoration: index == 0 ? decoration : null,
                  extent: const FractionalTableSpanExtent(1 / 6),
                );
              },
              rowBuilder: (index) {
                return TableSpan(
                  foregroundDecoration: index == 0 ? decoration : null,
                  extent: const FixedTableSpanExtent(100),
                );
              },
              cellBuilder: (context, vicinity) {
                final isHeader = vicinity.yIndex == 0;
                final escrow = !isHeader ? filteredEscrows[vicinity.yIndex - 1] : null;
                String label = '';

                if (isHeader) {
                  switch (vicinity.xIndex) {
                    case 0: label = 'ID';
                    case 1: label = 'Name';
                    case 2: label = 'Receiver Email';
                    case 3: label = 'Amount';
                    case 4: label = 'Status';
                    case 5: label = 'Payment Type';
                    case 6: label = 'Created';
                  }
                } else {
                  switch (vicinity.xIndex) {
                    case 0: label = escrow!.id.toString();
                    case 1: label = escrow!.escrowName;
                    case 2: label = escrow!.receiverEmail;
                    case 3: label = '₦${escrow!.formattedEscrowAmount}';
                    case 4: label = escrow!.escrow_Status;
                    case 5: label = escrow!.payment_type;
                    case 6: label = formatDate(escrow!.created_at);
                  }
                }

                return TableViewCell(
                  child: ColoredBox(
                    color: isHeader ? Colors.transparent : colorScheme.background,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: isHeader ? FontWeight.bold : null,
                            fontSize: 12,
                            color: isHeader ? null : colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM. d | HH:mm').format(date);
  }
}

class CardTableView extends ConsumerStatefulWidget {
  const CardTableView({super.key});

  @override
  ConsumerState<CardTableView> createState() => _CardTableViewState();
}

class _CardTableViewState extends ConsumerState<CardTableView> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(transactionProvider).Card ?? [];
    final searchQuery = ref.watch(searchProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final decoration = TableSpanDecoration(
      border: TableSpanBorder(trailing: BorderSide(color: theme.dividerColor)),
      consumeSpanPadding: true,
    );

    final filteredCards = cards.where((card) {
      final query = searchQuery.toLowerCase();
      return card.name.toLowerCase().contains(query) ||
          card.cardNumber.toLowerCase().contains(query) ||
          card.email.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        // Search Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!Responsive.isMobile(context))
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) =>
                  ref.read(searchProvider.notifier).state = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Search card',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            if (Responsive.isMobile(context))
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
          ],
        ),

        // Card Table
        SizedBox(
          height: 400,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: filteredCards.isEmpty
                ? const Center(child: Text("No cards found"))
                : TableView.builder(
              columnCount: 7,
              rowCount: filteredCards.length + 1,
              pinnedRowCount: 1,
              pinnedColumnCount: 1,
              columnBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FractionalTableSpanExtent(1 / 6),
              ),
              rowBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FixedTableSpanExtent(90),
              ),
              cellBuilder: (context, vicinity) {
                final isHeader = vicinity.yIndex == 0;
                String label = '';

                if (isHeader) {
                  switch (vicinity.xIndex) {
                    case 0: label = 'Name';
                    case 1: label = 'Brand';
                    case 2: label = 'Card Number';
                    case 3: label = 'Balance';
                    case 4: label = 'Expiry';
                    case 5: label = 'Created';
                    case 6: label = 'Email';
                    case 7: label = 'Card Id';
                  }
                } else {
                  final card = filteredCards[vicinity.yIndex - 1];
                  switch (vicinity.xIndex) {

                    case 0: label = card.name;
                    case 1: label = card.brand;
                    case 2: label = _maskCardNumber(card.cardNumber);
                    case 3: label = '${card.currency} ${card.balance.toStringAsFixed(2)}';
                    case 4: label = '${card.expiryMonth}/${card.expiryYear}';
                    case 5: label = _formatDate(card.dateCreated);
                    case 6: label = card.email;
                    case 7: label = card.cardId;
                  }
                }

                return TableViewCell(
                  child: ColoredBox(
                    color: isHeader ? Colors.transparent : colorScheme.background,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                            color: isHeader ? Colors.black : colorScheme.outline,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM. d, yyyy – HH:mm').format(date);
  }
}

class PayBillsTableView extends ConsumerStatefulWidget {
  const PayBillsTableView({super.key});

  @override
  ConsumerState<PayBillsTableView> createState() => _PayBillsTableViewState();
}

class _PayBillsTableViewState extends ConsumerState<PayBillsTableView> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final paybills = ref.watch(transactionProvider).Paybills ?? [];
    final searchQuery = ref.watch(searchProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final decoration = TableSpanDecoration(
      border: TableSpanBorder(trailing: BorderSide(color: theme.dividerColor)),
      consumeSpanPadding: true,
    );

    final filteredPaybills = paybills.where((bill) {
      final query = searchQuery.toLowerCase();
      return bill.name.toLowerCase().contains(query) ||
          bill.customerId.toLowerCase().contains(query) ||
          bill.mobileNumber.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        // Search Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!Responsive.isMobile(context))
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) =>
                  ref.read(searchProvider.notifier).state = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Search bills',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            if (Responsive.isMobile(context))
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
          ],
        ),

        // PayBills Table
        SizedBox(
          height: 400,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: filteredPaybills.isEmpty
                ? const Center(child: Text("No bills found"))
                : TableView.builder(
              columnCount: 13,
              rowCount: filteredPaybills.length + 1,
              pinnedRowCount: 1,
              pinnedColumnCount: 1,
              columnBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FractionalTableSpanExtent(1 / 7),
              ),
              rowBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FixedTableSpanExtent(90),
              ),
              cellBuilder: (context, vicinity) {
                final isHeader = vicinity.yIndex == 0;
                String label = '';

                if (isHeader) {
                  switch (vicinity.xIndex) {
                    case 0: label = 'Name';
                    case 1: label = 'Customer ID';
                    case 2: label = 'Amount';
                    case 3: label = 'Service Type';
                    case 4: label = 'Mobile Number';
                    case 5: label = 'Order Date';
                    case 6: label = 'Status';
                    case 7: label = 'customerId';
                    case 8: label = 'meterToken';
                    case 9: label = 'orderType';
                    case 10: label = 'deviceNumber';
                    case 11: label = 'mobileNetwork';
                    case 12: label = 'orderId';
                    case 13: label = 'operatorId';
                  }
                } else {
                  final bill = filteredPaybills[vicinity.yIndex - 1];
                  switch (vicinity.xIndex) {
                    case 0: label = bill.name;
                    case 1: label = bill.customerId;
                    case 2: label = '₦${bill.amount.toStringAsFixed(2)}';
                    case 3: label = bill.serviceType;
                    case 4: label = bill.mobileNumber;
                    case 5: label = _formatDate(bill.orderDate);
                    case 6: label = bill.status;
                    case 7: label = bill.customerId;
                    case 8: label = bill.meterToken;
                    case 9: label = bill.orderType;
                    case 10: label = bill.deviceNumber;
                    case 11: label = bill.mobileNetwork;
                    case 12: label = bill.orderId;
                    case 13: label = bill.operatorId;
                  }
                }

                return TableViewCell(
                  child: ColoredBox(
                    color: isHeader ? Colors.transparent : colorScheme.background,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                            color: isHeader ? Colors.black : colorScheme.outline,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM. d, yyyy – HH:mm').format(date);
  }
}

class PaymentDetailsTableView extends ConsumerStatefulWidget {
  const PaymentDetailsTableView({super.key});

  @override
  ConsumerState<PaymentDetailsTableView> createState() => _PaymentDetailsTableViewState();
}

class _PaymentDetailsTableViewState extends ConsumerState<PaymentDetailsTableView> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final payments = ref.watch(transactionProvider).Paymentlinks ?? [];
    final searchQuery = ref.watch(searchProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final decoration = TableSpanDecoration(
      border: TableSpanBorder(trailing: BorderSide(color: theme.dividerColor)),
      consumeSpanPadding: true,
    );

    final filteredPayments = payments.where((payment) {
      final query = searchQuery.toLowerCase();
      return payment.name.toLowerCase().contains(query) ||
          payment.customerId.toLowerCase().contains(query) ||
          payment.linkId.toLowerCase().contains(query) ||
          payment.isDisabled.toString().toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        // Search Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!Responsive.isMobile(context))
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) =>
                  ref.read(searchProvider.notifier).state = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Search payments',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            if (Responsive.isMobile(context))
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
          ],
        ),

        // Payment Details Table
        SizedBox(
          height: 400,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: filteredPayments.isEmpty
                ? const Center(child: Text("No payment records found"))
                : TableView.builder(
              columnCount: 9,
              rowCount: filteredPayments.length + 1,
              pinnedRowCount: 1,
              pinnedColumnCount: 1,
              columnBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FractionalTableSpanExtent(1 / 6),
              ),
              rowBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FixedTableSpanExtent(90),
              ),
              cellBuilder: (context, vicinity) {
                final isHeader = vicinity.yIndex == 0;
                String label = '';

                if (isHeader) {
                  switch (vicinity.xIndex) {
                    case 0: label = 'Name'; break;
                    case 1: label = 'CustomerId'; break;
                    case 2: label = 'AccountId'; break;
                    case 3: label = 'Amount'; break;
                    case 4: label = 'Description'; break;
                    case 5: label = 'Created First Date'; break;
                    case 6: label = 'linkUrl'; break;
                    case 7: label = 'linkId'; break;
                    case 8: label = 'payment made'; break;
                    case 9: label = 'isDisabled'; break;
                  }
                } else {
                  final payment = filteredPayments[vicinity.yIndex - 1];
                  switch (vicinity.xIndex) {
                    case 0: label = payment.name; break;
                    case 1: label = payment.customerId; break;
                    case 2: label = payment.accountId; break;
                    case 3: label = '₦${payment.amount}'; break;
                    case 4: label = payment.description; break;
                    case 5: label = payment.payment_details.isNotEmpty ? _formatDate(payment.payment_details.first.createdAt) : ''; break;
                    case 6: label = payment.linkUrl; break;
                    case 7: label = payment.linkId; break;
                    case 8: label = payment.payment_details.length.toString(); break;
                    case 9: label = payment.isDisabled.toString(); break;
                  }
                }

                return TableViewCell(
                  child: ColoredBox(
                    color: isHeader ? Colors.transparent : colorScheme.background,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                            color: isHeader ? Colors.black : colorScheme.outline,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM. d, yyyy – HH:mm').format(date);
  }
}


class NearMeDetailsTableView extends ConsumerStatefulWidget {
  const NearMeDetailsTableView({super.key});

  @override
  ConsumerState<NearMeDetailsTableView> createState() => _NearMeDetailsTableViewState();
}

class _NearMeDetailsTableViewState extends ConsumerState<NearMeDetailsTableView> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nearMeItems = ref.watch(transactionProvider).NearMeList ?? [];
    final searchQuery = ref.watch(searchProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final decoration = TableSpanDecoration(
      border: TableSpanBorder(trailing: BorderSide(color: theme.dividerColor)),
      consumeSpanPadding: true,
    );

    final filteredItems = nearMeItems.where((item) {
      final query = searchQuery.toLowerCase();
      return item.productName.toLowerCase().contains(query) ||
          item.productCategory.toLowerCase().contains(query) ||
          item.sellerName.toLowerCase().contains(query) ||
          item.brand.toLowerCase().contains(query) ||
          item.price.toLowerCase().contains(query);
    }).toList();

    final headers = [
      'Product ID', 'Category', 'Name', 'Title', 'Location', 'Brand', 'Type',
      'Condition', 'Description', 'Price', 'Delivery', 'Created At', 'Status',
      'Seller Name', 'Seller ID', 'Seller Email', 'Seller Phone', 'Customer ID'
    ];

    return Column(
      children: [
        // Search Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!Responsive.isMobile(context))
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) =>
                  ref.read(searchProvider.notifier).state = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Search nearby items',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            if (Responsive.isMobile(context))
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
          ],
        ),

        // NearMe Table View
        SizedBox(
          height: 400,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: filteredItems.isEmpty
                ? const Center(child: Text("No nearby products found"))
                : TableView.builder(
              columnCount: headers.length,
              rowCount: filteredItems.length + 1,
              pinnedRowCount: 1,
              pinnedColumnCount: 1,
              columnBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FractionalTableSpanExtent(1 / 5),
              ),
              rowBuilder: (index) => TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FixedTableSpanExtent(90),
              ),
              cellBuilder: (context, vicinity) {
                final isHeader = vicinity.yIndex == 0;
                String label = '';

                if (isHeader) {
                  label = headers[vicinity.xIndex];
                } else {
                  final item = filteredItems[vicinity.yIndex - 1];
                  switch (vicinity.xIndex) {
                    case 0: label = item.productId; break;
                    case 1: label = item.productCategory; break;
                    case 2: label = item.productName; break;
                    case 3: label = item.title; break;
                    case 4: label = item.location; break;
                    case 5: label = item.brand; break;
                    case 6: label = item.type; break;
                    case 7: label = item.condition; break;
                    case 8: label = item.description; break;
                    case 9: label = '₦${item.price}'; break;
                    case 10: label = item.delivery; break;
                    case 11: label = _formatDate(item.createdAt); break;
                    case 12: label = item.status; break;
                    case 13: label = item.sellerName; break;
                    case 14: label = item.sellerId; break;
                    case 15: label = item.sellerEmail; break;
                    case 16: label = item.sellerPhoneNumber; break;
                    case 17: label = item.customerId; break;
                    default: label = '';
                  }
                }

                return TableViewCell(
                  child: ColoredBox(
                    color: isHeader ? Colors.transparent : colorScheme.background,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                            color: isHeader ? Colors.black : colorScheme.outline,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM. d, yyyy – HH:mm').format(date);
  }
}

