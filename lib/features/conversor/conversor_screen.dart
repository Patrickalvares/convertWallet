import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../core/common_widgets/app_bar.dart';
import '../../core/common_widgets/bottom_navigation_bar.dart';
import '../../core/data/singleton/global.dart';
import '../../core/entities/currencys.dart';
import 'conversor_controller.dart';

class ConversorScreen extends StatefulWidget {
  const ConversorScreen({
    required this.controller,
    super.key,
  });
  final ConversorController controller;

  @override
  State<ConversorScreen> createState() => _ConversorScreenState();
}

class _ConversorScreenState extends State<ConversorScreen> {
  final TextEditingController amountController = TextEditingController();
  final NotchBottomBarController notchBottomBarController = NotchBottomBarController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: SimpleAppBarWidget(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<Currency>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blueGrey[400],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  ),
                                  hint: const Text(
                                    'Selecione uma moeda',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  value: Global.instance.selectedStandartCurrency,
                                  style: const TextStyle(color: Colors.white),
                                  iconDisabledColor: Colors.white,
                                  iconEnabledColor: Colors.white,
                                  dropdownColor: Colors.blueGrey[400],
                                  onChanged: widget.controller.setSourceCurrency,
                                  items: Currency.values.map<DropdownMenuItem<Currency>>((Currency currency) {
                                    return DropdownMenuItem<Currency>(
                                      value: currency,
                                      child: Text(
                                        '${currency.flagEmoji} ${currency.name} (${currency.code})',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<Currency>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blueGrey[400],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  ),
                                  hint: const Text(
                                    'Selecione uma moeda',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  value: widget.controller.selectedTargetCurrency,
                                  style: const TextStyle(color: Colors.white),
                                  iconDisabledColor: Colors.white,
                                  iconEnabledColor: Colors.white,
                                  dropdownColor: Colors.blueGrey[400],
                                  onChanged: widget.controller.setTargetCurrency,
                                  items: Currency.values.map<DropdownMenuItem<Currency>>((Currency currency) {
                                    return DropdownMenuItem<Currency>(
                                      value: currency,
                                      child: Text(
                                        '${currency.flagEmoji} ${currency.name} (${currency.code})',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          controller: amountController,
                          autofillHints: ['Buscar por moeda'],
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.white),
                            hintStyle: const TextStyle(color: Colors.white),
                            hintText: 'Valor a ser convertido',
                            filled: true,
                            fillColor: Colors.blueGrey[400],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          controller: widget.controller.outputController,
                          autofillHints: ['Buscar por moeda'],
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.white),
                            hintStyle: const TextStyle(color: Colors.white),
                            hintText: 'Conversão',
                            filled: true,
                            fillColor: Colors.blueGrey[400],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final amount = double.tryParse(amountController.text);
                            if (amount != null) {
                              widget.controller.convert(amount);
                            }
                          },
                          child: const Text('Converter'),
                        ),
                        const SizedBox(height: 16),
                        if (widget.controller.convertedValue != null)
                          Text(
                            'Valor convertido: ${widget.controller.convertedValue.toString()}',
                            style: const TextStyle(fontSize: 20),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          StyledBottomNavigationBar(
            notchBottomBarController: notchBottomBarController,
          ),
        ],
      ),
    );
  }
}
