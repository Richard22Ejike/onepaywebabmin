import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counter = StateProvider((ref) => 0);

class SelectedPageProvider extends ChangeNotifier {
  int selectedPage;

  SelectedPageProvider({
    this.selectedPage = 0,
  });

  void changePage(int newValue) {
    selectedPage = newValue;
    notifyListeners();
  }
}