import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../core/common_widgets/app_bar.dart';
import '../../core/common_widgets/bottom_navigation_bar.dart';
import '../../core/entities/currencys.dart';
import '../../core/global.dart';
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
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blueGrey.shade50,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: SimpleAppBarWidget(),
          ),
          body: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      children: [
                        Visibility(
                          visible: !widget.controller.getCurrencyValuesLoading,
                          replacement: Padding(
                            padding: const EdgeInsets.only(top: 300),
                            child: CircularProgressIndicator(
                              strokeWidth: 10,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
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
                                  items: Currency.values.where((currency) => currency != widget.controller.selectedTargetCurrency).map<DropdownMenuItem<Currency>>((Currency currency) {
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
                                  items: Currency.values.where((currency) => currency != Global.instance.selectedStandartCurrency).map<DropdownMenuItem<Currency>>((Currency currency) {
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
                                  controller: widget.controller.amountController,
                                  onChanged: (value) {
                                    final filteredValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                                    if (filteredValue.isNotEmpty) {
                                      if (filteredValue.length > 2) {
                                        final intPart = filteredValue.substring(0, filteredValue.length - 2).replaceAll(RegExp(r'^0+'), '');
                                        final decPart = filteredValue.substring(filteredValue.length - 2);
                                        widget.controller.amountController.value = TextEditingValue(
                                          text: ('$intPart,$decPart'),
                                          selection: TextSelection.collapsed(offset: '$intPart,$decPart'.length),
                                        );
                                      } else if (filteredValue.length == 2) {
                                        widget.controller.amountController.value = TextEditingValue(
                                          text: '0,$filteredValue',
                                          selection: TextSelection.collapsed(offset: '0,$filteredValue'.length),
                                        );
                                      } else {
                                        widget.controller.amountController.value = TextEditingValue(
                                          text: '0,0$filteredValue',
                                          selection: TextSelection.collapsed(offset: '0,0$filteredValue'.length),
                                        );
                                      }
                                      final amount = double.tryParse(widget.controller.amountController.text.replaceAll(',', '.'));
                                      if (amount != null) {
                                        widget.controller.convert(amount);
                                        widget.controller.amountController.text = '${Global.instance.selectedStandartCurrency.sifra} ${widget.controller.amountController.text.replaceAll('.', ',')}';
                                      } else {
                                        widget.controller.outputController.clear();
                                      }
                                    } else {
                                      widget.controller.amountController.clear();
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints.tightFor(width: 220),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(
                                            Colors.blueGrey[400],
                                          ),
                                        ),
                                        onPressed: () {
                                          final amount = double.tryParse(widget.controller.amountController.text);
                                          if (amount != null) {
                                            widget.controller.convert(amount);
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000), color: Colors.blueGrey[400]),
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        icon: const Icon(Icons.swap_vert),
                                        color: Colors.white,
                                        iconSize: 35,
                                        onPressed: () {
                                          widget.controller.swapCurrencies();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: StyledBottomNavigationBar(
                      notchBottomBarController: notchBottomBarController,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
