import 'package:flutter/material.dart';

import '../controller/main_screen_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.controller, super.key});

  final MainScreenController controller;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isTargetByStandardRate = false;
  @override
  void initState() {
    super.initState();
    widget.controller.getCurrencyValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Valores de Câmbio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            iconSize: 35,
            onPressed: () {
              widget.controller.getCurrencyValues();
            },
          ),
          IconButton(
            icon: const Icon(Icons.currency_exchange_sharp),
            color: Colors.white,
            iconSize: 35,
            onPressed: () {
              isTargetByStandardRate = !isTargetByStandardRate;
              widget.controller.update();
            },
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          if (widget.controller.currencies.isEmpty || !widget.controller.getCurrencyValuesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            );
          }
          return ListView.builder(
            itemCount: widget.controller.currencies.length,
            itemBuilder: (context, index) {
              final currency = widget.controller.currencies[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.teal),
                  title: Text(
                    isTargetByStandardRate ? '${widget.controller.selectedCurrency.code}/${currency.code}' : '${currency.code}/${widget.controller.selectedCurrency.code}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    isTargetByStandardRate ? currency.standardByTargetValue.toStringAsFixed(2) : currency.targetByStandardRate.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
