
import 'package:flutter/material.dart';

import '../model/menu_model.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.person, title: 'User',),
    MenuModel(icon: Icons.sync_alt, title: 'Transactions'),
    MenuModel(icon: Icons.account_balance_wallet, title: 'Escrows'),
    MenuModel(icon: Icons.credit_card, title: 'Card'),
    MenuModel(icon: Icons.receipt, title: 'Paybills'),
    MenuModel(icon: Icons.link, title: 'Paymentlinks'),
    MenuModel(icon: Icons.shop, title: 'Near Me'),
    MenuModel(icon: Icons.logout, title: 'SignOut'),
  ];
}
