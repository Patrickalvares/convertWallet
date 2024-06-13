import 'package:flutter/material.dart';

abstract class BaseController with ChangeNotifier {
  void update() {
    notifyListeners();
  }
}
