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
    var list = await App().cetusApi.loadCetusPositions(
      widget.arg.connection.address,
    );
    setState(() {
      cetusPositions = list;
    });
  }

  List<Widget> buildContent(BuildContext context) {
    List<Widget> result = [];
    for (CetusPoolPosition position in cetusPositions) {
      result.add(
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: DesignColors.fore(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                position.id,
                style: TextStyle(
                  fontSize: 24,
                  color: DesignColors.mainBackgroundColor,
                ),
              ),
              Text(
                position.poolId,
                style: TextStyle(
                  fontSize: 16,
                  color: DesignColors.mainBackgroundColor,
                ),
              ),
              Text(
                position.coinTypeA,
                style: TextStyle(
                  fontSize: 16,
                  color: DesignColors.mainBackgroundColor,
                ),
              ),
              Text(
                position.coinTypeB,
                style: TextStyle(
                  fontSize: 16,
                  color: DesignColors.mainBackgroundColor,
                ),
              ),
            ],
          ),
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
