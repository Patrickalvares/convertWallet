import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../core/common_widgets/app_bar.dart';
import '../../../../core/common_widgets/bottom_navigation_bar.dart';
import '../../../../core/domain/entities/currencys.dart';
import '../controller/main_screen_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.controller, super.key});

  final MainScreenController controller;

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
      widget.controller.ininialized();
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Currency>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blueGrey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            ),
                            hint: const Text('Selecione uma moeda'),
                            value: widget.controller.selectedCurrency,
                            onChanged: (Currency? newValue) {
                              setState(() {
                                widget.controller.selectedCurrency = newValue!;
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
                        IconButton(
                          icon: const Icon(Icons.currency_exchange_sharp),
                          color: Colors.blueGrey.shade700,
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              isTargetByStandardRate = !isTargetByStandardRate;
                            });
                            widget.controller.update();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
                    child: TextFormField(
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
                        hintText: 'Buscar por moeda',
                        filled: true,
                        fillColor: Colors.blueGrey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Visibility(
                      replacement: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
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
                      visible: !(widget.controller.currencieByCurrencys.isEmpty || !widget.controller.getCurrencyValuesLoading),
                      child: RefreshIndicator(
                        strokeWidth: 3,
                        color: Colors.blueGrey.shade700,
                        onRefresh: () => widget.controller.getCurrencyValues(),
                        child: ListView.builder(
                          itemCount: widget.controller.currencieByCurrencysFiltred.length + 1, // Incrementa o itemCount
                          itemBuilder: (context, index) {
                            if (index == widget.controller.currencieByCurrencysFiltred.length) {
                              return const SizedBox(
                                height: 100,
                              );
                            }

                            final currencieByCurrency = widget.controller.currencieByCurrencysFiltred[index];
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
                                    '${currencieByCurrency.code}/${widget.controller.selectedCurrency.code}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${currencieByCurrency.targetCurrency.name} / ${widget.controller.selectedCurrency.name}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.controller.selectedCurrency.sifra + currencieByCurrency.targetByStandardRate.toStringAsFixed(2).replaceAll('.', ','),
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
                                    '${widget.controller.selectedCurrency.code}/${currencieByCurrency.code}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${widget.controller.selectedCurrency.name} / ${currencieByCurrency.targetCurrency.name}',
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
              StyledBottomNavigationBar(notchBottomBarController: notchBottomBarController),
            ],
          );
        },
      ),
    );
  }
}