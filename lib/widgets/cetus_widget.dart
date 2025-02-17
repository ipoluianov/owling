import 'package:flutter/material.dart';
import 'package:owling/core/common/cetus.dart';

import '../core/base/app.dart';

class CetusWidget extends StatefulWidget {
  final String address;

  const CetusWidget(this.address, {super.key});

  @override
  CetusWidgetState createState() => CetusWidgetState();
}

class CetusWidgetState extends State<CetusWidget> {

  String status = "init";
  CetusOfAddress? cetusOfAddress;

  @override
  void initState() {
    super.initState();
    updateCetus();
  }

  Future<void> updateCetus() async {
    setState(() {
      status = "loading";
    });
    cetusOfAddress = await App().cetusApi.loadCetusInfoOfAccount(widget.address);
    setState(() {
      status = "loaded";
    });
  }

  Widget buildCetusInfo() {
    if (cetusOfAddress == null) {
      return Text("No Cetus Info");
    }
    return Column(
      children: cetusOfAddress!.positions.map((position) {
        return Column(
          children: [
            Text(position.poolId),
            Text(position.coinTypeA),
            Text(position.coinTypeB),
            Text(position.rewards.reward1.coinType),
            Text(position.rewards.reward1.amount.toString()),
            Text(position.rewards.reward2.coinType),
            Text(position.rewards.reward2.amount.toString()),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Cetus Info"),
        Text(widget.address),
        Text(status),
        buildCetusInfo(),
      ],
    );
  }
}
