import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../../../core/common_widgets/app_bar.dart';
import '../../../../core/common_widgets/bottom_navigation_bar.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  NotchBottomBarController notchBottomBarController = NotchBottomBarController(index: 2);
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
