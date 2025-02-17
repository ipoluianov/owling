
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:owling/core/design.dart';
import 'package:owling/core/navigation.dart';
import 'package:owling/core/navigation/bottom_navigator.dart';
import 'package:owling/core/navigation/left_navigator.dart';
import 'package:owling/core/route_generator.dart';
import 'package:owling/forms/home/home_config.dart';
import 'package:owling/widgets/title_bar/title_bar.dart';

import 'home_item.dart';
import 'home_item_node_info.dart';

class HomeForm extends StatefulWidget {
  final HomeFormArgument arg;
  const HomeForm(this.arg, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeFormSt();
  }
}

class HomeFormSt extends State<HomeForm> {
  final ScrollController _scrollController = ScrollController();

  //late Timer _timer;

  @override
  void initState() {
    super.initState();
    load();

    /*_timer = Timer.periodic(const Duration(seconds: 1), (t) {
      load();
    });*/
  }

  @override
  void dispose() {
    //_timer.cancel();
    super.dispose();
  }

  bool loading = false;
  bool loaded = false;
  HomeConfig currentConfig = HomeConfig([]);

  bool saved = false;

  void reload() {
    loaded = false;
    load();
  }

  void load() {
    if (loading || loaded) {
      return;
    }

    setState(() {
      loading = true;
    });

    initDefault();

    setState(() {
      loading = false;
      loaded = true;
    });
  }

  void save() {
    //print(saveToString());
    //if (saved) return;
    //asdada = 4;

    //String content = saveToString();
    saved = true;
  }

  void loadConfig(String config) {
    currentConfig = HomeConfig.fromJson(jsonDecode(config));
    setState(() {});
  }

  void initDefault() {
    loadConfig(
      "{\"items\":[{\"props\": [ {\"name\":\"type\", \"value\":\"node_info\"}]}]}",
    );
  }

  String saveToString() {
    return jsonEncode(currentConfig.toJson());
  }

  Widget buildItem(HomeItem innerItem) {
    List<Widget> ws = [];
    ws.add(
      Container(
        constraints: const BoxConstraints(minHeight: 6),
        color: Colors.transparent,
      ),
    );
    ws.add(innerItem);

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
      //constraints: BoxConstraints(maxWidth: 500),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ws,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoading(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black26,
        child: const Center(
          child: Text(
            "loading",
            style: TextStyle(
              color: Colors.blue,
              fontFamily: "BrunoAce",
              fontSize: 36,
            ),
          ),
        ),
      ),
    );
  }

  void onAdd() {
    Navigator.of(context)
        .pushNamed(
          "/home_add_item",
          arguments: HomeAddItemArgument(widget.arg.connection),
        )
        .then((value) {
          if (value is HomeConfigItem) {
            if (value.get("type") == "map") {
              Navigator.of(context)
                  .pushNamed(
                    "/home_config_form",
                    arguments: HomeConfigFormArgument(
                      widget.arg.connection,
                      value,
                    ),
                  )
                  .then((editedValue) {
                    if (editedValue is HomeConfigItem) {
                      currentConfig.items.add(editedValue);
                      setState(() {});
                      save();
                    }
                  });
            } else {
              currentConfig.items.add(value);
              setState(() {});
              save();
            }
          }
        });
  }

  void onEdit(HomeConfigItem item) {
    // home_config_form
    Navigator.of(context)
        .pushNamed(
          "/home_config_form",
          arguments: HomeConfigFormArgument(widget.arg.connection, item),
        )
        .then((value) {
          if (value != null) {
            setState(() {});
            save();
          }
        });
  }

  void onRemove(HomeConfigItem item) {
    for (var i in currentConfig.items) {
      if (i == item) {
        setState(() {
          currentConfig.items.remove(item);
        });
        save();
        return;
      }
    }
  }

  void onUp(HomeConfigItem item) {
    int foundIndex = -1;
    for (int i = 0; i < currentConfig.items.length; i++) {
      if (currentConfig.items[i] == item) {
        foundIndex = i;
        break;
      }
    }

    if (foundIndex < 0) {
      return;
    }

    if (foundIndex == 0) {
      return;
    }
    var tempItem = currentConfig.items[foundIndex - 1];
    currentConfig.items[foundIndex - 1] = currentConfig.items[foundIndex];
    currentConfig.items[foundIndex] = tempItem;

    setState(() {});
    save();
  }

  void onDown(HomeConfigItem item) {
    int foundIndex = -1;
    for (int i = 0; i < currentConfig.items.length; i++) {
      if (currentConfig.items[i] == item) {
        foundIndex = i;
        break;
      }
    }

    if (foundIndex < 0) {
      return;
    }

    if (foundIndex == currentConfig.items.length - 1) {
      return;
    }
    var tempItem = currentConfig.items[foundIndex + 1];
    currentConfig.items[foundIndex + 1] = currentConfig.items[foundIndex];
    currentConfig.items[foundIndex] = tempItem;

    setState(() {});
    save();
  }

  List<Widget> items() {
    List<Widget> result = [];

    if (loading) {
      result.add(buildLoading(context));
      return result;
    }

    for (var item in currentConfig.items) {
      if (item.get("type") == "node_info") {
        result.add(
          buildItem(
            HomeItemNodeInfo(widget.arg, item, onEdit, onRemove, onUp, onDown),
          ),
        );
      }
    }
    return result;
    /*return [
      buildItem(HomeItemNodeInfo(widget.arg, "")),
      buildItem(HomeItemMap(widget.arg, "")),
    ];*/
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
            "Node",
            actions: <Widget>[
              loaded
                  ? buildActionButton(
                    context,
                    Icons.add,
                    "Add item to the home screen",
                    () {
                      onAdd();
                    },
                  )
                  : Container(),
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
                            child: Wrap(children: items()),
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

  int currentTitleKey = 0;
  void incrementTitleKey() {
    setState(() {
      currentTitleKey++;
    });
  }

  String getCurrentTitleKey() {
    return "units_$currentTitleKey";
  }
}
