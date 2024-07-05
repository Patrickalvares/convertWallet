import 'dart:ui';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../core/common_widgets/app_bar.dart';
import '../../../core/common_widgets/bottom_navigation_bar.dart';
import '../../../core/data/global.dart';
import '../../../core/domain/entities/currencys.dart';
import '../controller/quotes_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.controller, super.key});

  final QuotesController controller;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isTargetByStandardRate = false;
  final buscaController = TextEditingController();
  NotchBottomBarController notchBottomBarController = NotchBottomBarController(index: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.controller.getCurrencyValues();
      widget.controller.initialized();
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
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      child: Visibility(
                        replacement: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const SizedBox(
                                height: 130,
                              );
                            }
                            return Shimmer(
                              color: Colors.blueGrey.shade200,
                              child: Card(
                                color: Colors.blueGrey.shade100,
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: const ListTile(
                                  leading: Text(
                                    '',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  title: Text(
                                    '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        visible: !(Global.instance.currencies.isEmpty || !widget.controller.getCurrencyValuesLoading),
                        child: RefreshIndicator(
                          strokeWidth: 3,
                          color: Colors.blueGrey.shade700,
                          onRefresh: () => widget.controller.getCurrencyValues(),
                          child: ListView.builder(
                            itemCount: widget.controller.currencieByCurrencysFiltred.length + 2,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return const SizedBox(
                                  height: 130,
                                );
                              }
                              if (index == widget.controller.currencieByCurrencysFiltred.length + 1) {
                                return const SizedBox(
                                  height: 95,
                                );
                              }
                              final currencieByCurrency = widget.controller.currencieByCurrencysFiltred[index - 1];
                              return Card(
                                color: Colors.blueGrey.shade100,
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Visibility(
                                  visible: isTargetByStandardRate,
                                  replacement: ListTile(
                                    leading: Text(
                                      currencieByCurrency.targetCurrency.flagEmoji,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    title: Text(
                                      '${currencieByCurrency.code}/${Global.instance.selectedStandartCurrency.code}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${currencieByCurrency.targetCurrency.name} / ${Global.instance.selectedStandartCurrency.name}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          Global.instance.selectedStandartCurrency.sifra + currencieByCurrency.targetByStandardRate.toStringAsFixed(2).replaceAll('.', ','),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Text(
                                      currencieByCurrency.targetCurrency.flagEmoji,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    title: Text(
                                      '${Global.instance.selectedStandartCurrency.code}/${currencieByCurrency.code}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${Global.instance.selectedStandartCurrency.name} / ${currencieByCurrency.targetCurrency.name}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          currencieByCurrency.targetCurrency.sifra + currencieByCurrency.standardByTargetValue.toStringAsFixed(2).replaceAll('.', ','),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 2,
                      sigmaY: 2,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0),
                            Colors.black.withOpacity(0.05),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 5),
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
                                    hint: const Text('Selecione uma moeda'),
                                    value: Global.instance.selectedStandartCurrency,
                                    style: const TextStyle(color: Colors.white),
                                    iconDisabledColor: Colors.white,
                                    iconEnabledColor: Colors.white,
                                    dropdownColor: Colors.blueGrey[400],
                                    onChanged: (Currency? newValue) {
                                      setState(() {
                                        widget.controller.changeCurrency(newValue!);
                                      });
                                      widget.controller.getCurrencyValues();
                                      widget.controller.update();
                                    },
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
                                const SizedBox(width: 5),
                                Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000), color: Colors.blueGrey[400]),
                                  height: 50,
                                  width: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.currency_exchange_sharp),
                                    color: Colors.white,
                                    iconSize: 25,
                                    onPressed: () {
                                      setState(() {
                                        isTargetByStandardRate = !isTargetByStandardRate;
                                      });
                                      widget.controller.update();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: buscaController,
                              autofillHints: ['Buscar por moeda'],
                              onChanged: widget.controller.filtrarCurrencieByCurrencys,
                              onSaved: (value) {
                                if (value != null) {
                                  widget.controller.filtrarCurrencieByCurrencys(value);
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.white),
                                hintStyle: const TextStyle(color: Colors.white),
                                hintText: 'Buscar por moeda',
                                filled: true,
                                fillColor: Colors.blueGrey[400],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 2,
                      sigmaY: 2,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0),
                            Colors.black.withOpacity(0.05),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: const SizedBox(
                        height: 60,
                      ),
                    ),
                  ),
                ),
              ),
              StyledBottomNavigationBar(notchBottomBarController: notchBottomBarController),
            ],
          );
        },
      ),
    );
  }
}
