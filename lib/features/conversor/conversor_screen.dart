import 'dart:async';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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
  late KeyboardVisibilityController keyboardVisibilityController;
  late StreamSubscription<bool> keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.initialize();
    });

    keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilitySubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  void dispose() {
    keyboardVisibilitySubscription.cancel();
    amountController.dispose();
    super.dispose();
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
          Visibility(
            visible: !widget.controller.getCurrencyValuesLoading,
            replacement: const CircularProgressIndicator(),
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, _) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Moeda de Origem:',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<Currency>(
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
                          const SizedBox(height: 16),
                          Text(
                            'Moeda de Destino:',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<Currency>(
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
                          const SizedBox(height: 16),
                          Text(
                            'Valor a ser Convertido:',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            controller: amountController,
                            onChanged: (value) {
                              final filteredValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                              if (filteredValue.isNotEmpty) {
                                if (filteredValue.length > 2) {
                                  final intPart = filteredValue.substring(0, filteredValue.length - 2).replaceAll(RegExp(r'^0+'), '');
                                  final decPart = filteredValue.substring(filteredValue.length - 2);
                                  amountController.value = TextEditingValue(
                                    text: ('$intPart,$decPart'),
                                    selection: TextSelection.collapsed(offset: '$intPart,$decPart'.length),
                                  );
                                } else if (filteredValue.length == 2) {
                                  amountController.value = TextEditingValue(
                                    text: '0,$filteredValue',
                                    selection: TextSelection.collapsed(offset: '0,$filteredValue'.length),
                                  );
                                } else {
                                  amountController.value = TextEditingValue(
                                    text: '0,0$filteredValue',
                                    selection: TextSelection.collapsed(offset: '0,0$filteredValue'.length),
                                  );
                                }
                                final amount = double.tryParse(amountController.text.replaceAll(',', '.'));
                                if (amount != null) {
                                  widget.controller.convert(amount);
                                  amountController.text = '${Global.instance.selectedStandartCurrency.sifra} ${amountController.text.replaceAll('.', ',')}';
                                } else {
                                  widget.controller.outputController.clear();
                                }
                              } else {
                                amountController.clear();
                                widget.controller.outputController.clear();
                              }
                            },
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(color: Colors.white),
                              hintText: 'Digite o valor',
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
                          Text(
                            'Valor Convertido:',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            controller: widget.controller.outputController,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(color: Colors.white),
                              hintText: 'Resultado',
                              filled: true,
                              fillColor: Colors.blueGrey[400],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            ),
                          ),
                          const SizedBox(height: 35),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(width: 200),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    Colors.blueGrey[400],
                                  ),
                                ),
                                onPressed: () {
                                  final amount = double.tryParse(amountController.text);
                                  if (amount != null) {
                                    widget.controller.convert(amount);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.change_circle_outlined, color: Colors.white, size: 35),
                                      SizedBox(width: 10),
                                      Text(
                                        'Converter',
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isKeyboardVisible,
            child: StyledBottomNavigationBar(
              notchBottomBarController: notchBottomBarController,
            ),
          ),
        ],
      ),
    );
  }
}
