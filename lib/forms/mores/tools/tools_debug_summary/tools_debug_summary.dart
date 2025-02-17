import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:owling/core/design.dart';
import 'package:owling/core/navigation.dart';
import 'package:owling/core/navigation/bottom_navigator.dart';
import 'package:owling/core/navigation/left_navigator.dart';
import 'package:owling/core/route_generator.dart';
import 'package:owling/widgets/title_bar/title_bar.dart';

import '../../../../core/repository.dart';
import '../../more_form/more_button.dart';

class ToolsDebugSummaryForm extends StatefulWidget {
  final ToolsFormArgument arg;
  const ToolsDebugSummaryForm(this.arg, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ToolsDebugSummaryFormSt();
  }
}

class ToolsDebugSummaryFormSt extends State<ToolsDebugSummaryForm> {
  final ScrollController _scrollController = ScrollController();

  late Timer timerUpdate;

  @override
  void initState() {
    super.initState();

    timerUpdate = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      update();
    });
  }

  @override
  void dispose() {
    timerUpdate.cancel();
    super.dispose();
  }

  void update() {
    incrementTitleKey();
  }

  Widget buildHeader(BuildContext context, String header) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.green,
                width: 3,
              ),
            ),
          ),
          child: Text(
            header,
            style: TextStyle(
              fontSize: 24,
              color: DesignColors.fore(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildRepository(BuildContext context) {
    List<Widget> result = [
      Text("Update Time: ${DateTime.now()}"),
    ];
    return [
      buildHeader(context, "Repository"),
      Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: result,
        ),
      ),
    ];
  }

  List<Widget> buildContent(BuildContext context) {
    List<Widget> result = [];
    result.addAll(buildRepository(context));
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
            null,
            "Tool Debug Summary",
            actions: <Widget>[
              buildHomeButton(context),
            ],
            key: Key(getCurrentTitleKey()),
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

  String txtNodeName = "";
  final TextEditingController _textFieldController = TextEditingController();

  int currentTitleKey = 0;
  void incrementTitleKey() {
    setState(() {
      currentTitleKey++;
    });
  }

  String getCurrentTitleKey() {
    return "tools_" + currentTitleKey.toString();
  }
}
