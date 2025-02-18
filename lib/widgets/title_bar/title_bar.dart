import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owling/core/design.dart';
import 'package:owling/core/navigation.dart';
import 'package:owling/core/workspace/workspace.dart';
import 'package:owling/widgets/borders/border_02_titlebar.dart';

class TitleBar extends StatefulWidget implements PreferredSizeWidget {
  final Connection? connection;
  final String title;
  final String version;
  final List<Widget>? actions;
  const TitleBar(this.connection, this.title,
      {Key? key, this.actions, this.version = ""})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TitleBarSt();
  }

  @override
  Size get preferredSize {
    return const Size(0, 62);
  }
}

class TitleBarSt extends State<TitleBar> {
  bool serviceInfoLoaded = false;
  //late ServiceInfoResponse serviceInfo;

  @override
  void initState() {
    super.initState();
    loadNodeInfo();
    _timerTick = Timer.periodic(const Duration(milliseconds: 500), (t) {
      tick();
    });
  }

  @override
  void dispose() {
    _timerTick.cancel();
    super.dispose();
  }

  void loadNodeInfo() {
    if (widget.connection != null) {
    }
  }

  String nodeAddress() {
    if (widget.connection == null) {
      return "-";
    }
    return widget.connection!.address;
  }

  String nodeName() {
    if (widget.connection == null) {
      return "-";
    }
    if (serviceInfoLoaded) {
      return '---';
    }
    return "-"; //widget.connection!.address;
  }

  String titleLine() {
    if (widget.connection != null) {
      return "${nodeName()} - ${widget.title}";
    }
    return widget.title;
  }

  late Timer _timerTick;
  int tickCounter_ = 0;
  void tick() {
    if (widget.connection != null) {
      setState(() {
        tickCounter_++;
      });
    }
  }

  Widget subheader() {
    String text = "";
    Color color = Colors.grey.withOpacity(0.5);

    if (widget.connection != null) {
    }

    if (text.isEmpty) {
      text = "Client Version: v${widget.version}";
    }

    return Text(
      text,
      style: TextStyle(color: color, fontSize: 10),
    );
  }

  List<Widget> getActions() {
    if (widget.actions == null) {
      return [];
    }
    return widget.actions!;
  }

  Widget buildBackButton() {
    if (Navigator.of(context).canPop()) {
      return buildActionButton(context, Icons.arrow_back_ios, "Back", () {
        Navigator.of(context).pop();
      });
    }
    return buildActionButton(context, null, "", () {});
  }

  Widget buildBillingButton() {
    /*BillingSummary billingInfo = BillingSummary();

    bool usingLocalRouter = false;
    if (widget.connection != null) {
      usingLocalRouter =
          Repository().client(widget.connection!).usingLocalRouter();
    }
    bool usingDirectConnection = false;
    if (widget.connection != null) {
      usingDirectConnection =
          Repository().client(widget.connection!).usingDirectConnection();
    }

    if (widget.connection != null) {
      billingInfo = Repository().client(widget.connection!).billingInfo();
    }*/

    //Color colorOfValue = Colors.green;

    Widget innerWidget = Container();

    if (true) {
      innerWidget = const Center(
        child: Icon(
          Icons.radar,
          size: 32,
          color: Colors.green,
        ),
      );
    }

    if (true) {
      // Premium
      innerWidget = const Center(
        child: Icon(
          Icons.auto_awesome,
          size: 32,
          color: Colors.green,
        ),
      );
    }

    if (widget.connection != null) {
    }

    if (widget.connection == null) {
      innerWidget = const Image(
          image: AssetImage('assets/images/ios/Icon-App-40x40@1x.png'));
    }


    return GestureDetector(
      onTap: () {},
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: innerWidget,
                ),
              ),
            ),
            SizedBox(
              width: 52,
              height: 52,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: DesignColors.mainBackgroundColor,
        child: Stack(
          children: [
            Border02Painter.build(false, DesignColors.fore2()),
            Container(
              padding: const EdgeInsets.only(left: 3, top: 3, right: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBackButton(),
                  buildBillingButton(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 8, left: 12),
                      //color: Colors.yellow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              //color: Colors.cyan,
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                titleLine(),
                                style: TextStyle(
                                    color: DesignColors.fore(),
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              //color: Colors.cyan,
                              alignment: Alignment.topLeft,
                              child: subheader(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: getActions(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
