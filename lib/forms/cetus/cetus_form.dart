import 'package:flutter/material.dart';
import 'package:owling/core/base/app.dart';
import 'package:owling/core/common/cetus.dart';
import 'package:owling/core/design.dart';
import 'package:owling/core/navigation.dart';
import 'package:owling/core/navigation/bottom_navigator.dart';
import 'package:owling/core/navigation/left_navigator.dart';
import 'package:owling/core/route_generator.dart';
import 'package:owling/widgets/title_bar/title_bar.dart';

class CetusForm extends StatefulWidget {
  final CommonFormArgument arg;
  const CetusForm(this.arg, {super.key});

  @override
  State<StatefulWidget> createState() {
    return CetusFormState();
  }
}

class CetusFormState extends State<CetusForm> {
  final ScrollController _scrollController = ScrollController();

  List<CetusPoolPosition> cetusPositions = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    /*await App().cetusApi.fetchPoolObject(
      "0xe01243f37f712ef87e556afb9b1d03d0fae13f96d324ec912daffc339dfdcbd2",
    );*/

    var list = await App().cetusApi.loadCetusPositions(
      widget.arg.connection.address,
    );
    if (!mounted) {
      return;
    }

    App().cetusApi.getPoolsByCoins(
      "0x0000000000000000000000000000000000000000000000000000000000000002::sui::SUI",
      "0xdeeb7a4662eec9f2f3def03fb937a663dddaa2e215b8078a284d026b7946c270::deep::DEEP",
    );

    setState(() {
      cetusPositions = list;
    });
  }

  List<Widget> buildContent(BuildContext context) {
    List<Widget> result = [];
    for (CetusPoolPosition position in cetusPositions) {
      var txt = "posId: ${position.id}";
      txt += "\r\n";
      txt += "poolId: ${position.poolId}";
      txt += "\r\n";
      txt += "coinTypeA: ${position.coinTypeA}";
      txt += "\r\n";
      txt += "coinTypeB: ${position.coinTypeB}";
      txt += "\r\n";
      txt += "tickLowerIndex: ${position.tickLowerIndex}";
      txt += "\r\n";
      txt += "tickUpperIndex: ${position.tickUpperIndex}";
      txt += "\r\n";
      txt += "liquidity: ${position.liquidity}";
      txt += "\r\n";
      txt += "index: ${position.index}";
      txt += "\r\n";
      txt += "liquidity: ${position.liquidity}";
      txt += "\r\n";
      txt += "feeA: ${position.feeA}";
      txt += "\r\n";
      txt += "feeB: ${position.feeB}";
      txt += "\r\n";
      txt += "=========================================";
      txt += "\r\n";
      txt += "PARSED:";
      txt += "\r\n";
      txt +=
          "feeANormalized: ${position.feeANormalized} ${position.coinInfoA.symbol}";
      txt += "\r\n";
      txt +=
          "feeBNormalized: ${position.feeBNormalized} ${position.coinInfoB.symbol}";
      txt += "\r\n";
      txt += "rewards:";
      txt += "\r\n";
      txt +=
          "  rewardA: ${position.rewards.reward1.amountNormalized} ${position.rewards.reward1.coinInfo.symbol}";
      txt += "\r\n";
      txt +=
          "  rewardB: ${position.rewards.reward2.amountNormalized} ${position.rewards.reward2.coinInfo.symbol}";
      txt += "\r\n";
      txt += "CurrentTickIndex: ${position.poolObject.currentTickIndex}";
      txt += "\r\n";
      txt += "Price: ${position.poolObject.price}";

      result.add(
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Text(txt),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool narrow = constraints.maxWidth < constraints.maxHeight;
        bool showLeft = !narrow;
        bool showBottom = narrow;

        return Scaffold(
          appBar: TitleBar(
            widget.arg.connection,
            "Cetus",
            actions: <Widget>[buildHomeButton(context)],
          ),
          body: Container(
            color: DesignColors.mainBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LeftNavigator(showLeft),
                      Expanded(
                        child: DesignColors.buildScrollBar(
                          controller: _scrollController,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: buildContent(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BottomNavigator(showBottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
