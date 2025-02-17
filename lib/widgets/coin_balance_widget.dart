import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owling/common/cetus.dart';

import '../base/app.dart';
import '../base/get_balance.dart';

class CoinBalanceWidget extends StatefulWidget {
  final String address;
  final String coinType;

  const CoinBalanceWidget(this.address, this.coinType, {super.key});

  @override
  CoinBalanceWidgetState createState() => CoinBalanceWidgetState();
}

class CoinBalanceWidgetState extends State<CoinBalanceWidget> {
  CoinInfo coinInfo = CoinInfo();

  String balance = "";
  String error = "";

  // timer to update balance
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) async {
      await updateBalance();
    });
    updateBalance();
  }

  Future<void> updateBalance() async {
    try {
      var bal = await getSuiBalance(
        App().client,
        widget.address,
        widget.coinType,
      );
      var balStr = await bal.amountString();
      coinInfo = await App().getCoinInfo(widget.coinType);
      setState(() {
        balance = balStr;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(coinInfo.symbol), Text(balance), Text(error)]);
  }
}
