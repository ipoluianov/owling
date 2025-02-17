import 'package:flutter/material.dart';
import 'package:owling/core/design.dart';
import 'package:owling/core/navigation.dart';
import 'package:owling/core/navigation/bottom_navigator.dart';
import 'package:owling/core/navigation/left_navigator.dart';
import 'package:owling/core/route_generator.dart';
import 'package:owling/widgets/title_bar/title_bar.dart';

import 'more_button.dart';

class MoreForm extends StatefulWidget {
  final MoreFormArgument arg;
  const MoreForm(this.arg, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MoreFormSt();
  }
}

class MoreFormSt extends State<MoreForm> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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

  List<Widget> buildAppInfo(BuildContext context) {
    List<Widget> result = [
      MoreButton(() {
        Navigator.pushNamed(context, "/tools_menu",
            arguments: ToolsFormArgument());
      }, "Tools", const Icon(Icons.apps, size: 48), 3),
      MoreButton(() {
        Navigator.pushNamed(context, "/appearance",
            arguments: AppearanceFormArgument(widget.arg.connection));
      }, "Appearance", const Icon(Icons.settings, size: 48), 3),
      MoreButton(() {
        Navigator.pushNamed(context, "/about",
            arguments: AboutFormArgument(widget.arg.connection));
      }, "About", const Icon(Icons.info_outline, size: 48), 5),
    ];
    return [buildHeader(context, "Application"), Wrap(children: result)];
  }

  List<Widget> buildContent(BuildContext context) {
    List<Widget> result = [];
    result.addAll(buildAppInfo(context));
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
            "More",
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
  //final TextEditingController _textFieldController = TextEditingController();

  int currentTitleKey = 0;
  void incrementTitleKey() {
    setState(() {
      currentTitleKey++;
    });
  }

  String getCurrentTitleKey() {
    return "units_" + currentTitleKey.toString();
  }

  /*Future<void> _displayNodeNameDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: DesignColors.back(),
            shadowColor: DesignColors.fore(),
            title: const Text('Rename node'),
            content: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  txtNodeName = value;
                });
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Node Name"),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: const SizedBox(
                  width: 70,
                  child: Center(child: Text('OK')),
                ),
                onPressed: () {
                  setState(() {
                  });
                },
              ),
              OutlinedButton(
                child: const SizedBox(
                  width: 70,
                  child: Center(child: Text('Cancel')),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }*/
}
