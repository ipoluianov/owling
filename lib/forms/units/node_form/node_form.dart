import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owling/core/design.dart';
import 'package:owling/core/navigation.dart';
import 'package:owling/core/navigation/bottom_navigator.dart';
import 'package:owling/core/navigation/left_navigator.dart';
import 'package:owling/core/route_generator.dart';
import 'package:owling/widgets/load_indicator/load_indicator.dart';
import 'package:owling/widgets/title_bar/title_bar.dart';

class NodeForm extends StatefulWidget {
  final NodeFormArgument arg;
  const NodeForm({Key? key, required this.arg}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NodeFormSt();
  }
}

class NodeFormSt extends State<NodeForm> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    load();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      load();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool loading = false;
  bool loaded = false;

  String loadingError = "";
  String operationError = "";

  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();

  bool addingUnits = false;

  void load() {
  }

  Widget buildToolbar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> leftButtons = [];
        List<Widget> rightButtons = [];

        leftButtons.add(buildAddButton(context));

        leftButtons.add(Expanded(child: Container()));
        leftButtons.addAll(rightButtons);
        return Row(
          children: leftButtons,
        );
      },
    );
  }

  Widget buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildToolbar(context),
        Container(
          color: DesignColors.fore2(),
          height: 1,
        ),
        buildContent(context),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    if (loading && !loaded) {
      return const LoadIndicator();
    }
    return buildEmptyUnitList(context);
  }

  Widget buildError(BuildContext context) {
    if (loadingError.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red.withOpacity(0.5),
            ),
            constraints: const BoxConstraints(minWidth: 200),
            padding: const EdgeInsets.all(10),
            child: Text(
              "Error: " + loadingError,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void addUnit() {
  }

  Widget buildAddButton(BuildContext context) {
    return buildActionButton(context, Icons.add, "Add Unit", () {
      addUnit();
    });
  }

  Widget buildEmptyUnitList(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: Scrollbar(
            controller: scrollController2,
            thumbVisibility: true,
            thickness: 15,
            radius: const Radius.circular(5),
            child: SingleChildScrollView(
              controller: scrollController2,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "No units to display",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white30,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        const Text(
                          "Add a unit",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white30,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              addUnit();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(32)),
                            ),
                            label: const Text("Add a Unit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        const Text(
                          "Add local system units:\r\nMemory & Network & Storage",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white30,
                          ),
                        ),
                        addingUnits
                            ? const Text("adding ...")
                            : Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: ElevatedButton(
                                    onPressed: () {
                                      
                                    },
                                    child:
                                        const Text("Add local system units"))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
            "Units",
            actions: [
              buildHomeButton(context),
            ],
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
                        child: Stack(
                          children: [
                            buildForm(context),
                            buildError(context),
                          ],
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
