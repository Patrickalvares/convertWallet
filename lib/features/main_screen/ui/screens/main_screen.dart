import 'package:flutter/material.dart';

import '../controller/main_screen_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.controller, super.key});

  final MainScreenController controller;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
                    '${widget.controller.selectedCurrency.code}/${currency.code}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    currency.rate.toStringAsFixed(2),
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
