import 'package:flutter/material.dart';

class SimpleAppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'ConvertWallet',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 2,
      backgroundColor: Colors.blueGrey.shade700,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [],
    );
  }
}
