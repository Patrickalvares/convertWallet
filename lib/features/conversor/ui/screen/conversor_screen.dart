import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../../../core/common_widgets/app_bar.dart';
import '../../../../core/common_widgets/bottom_navigation_bar.dart';

class ConversorScreen extends StatefulWidget {
  const ConversorScreen({super.key});

  @override
  State<ConversorScreen> createState() => _ConversorScreenState();
}

class _ConversorScreenState extends State<ConversorScreen> {
  NotchBottomBarController notchBottomBarController = NotchBottomBarController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: SimpleAppBarWidget(),
      ),
      body: Column(
        children: [
          StyledBottomNavigationBar(
            notchBottomBarController: notchBottomBarController,
          ),
        ],
      ),
    );
  }
}
