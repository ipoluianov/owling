import 'package:flutter/material.dart';
import 'package:owling/core/navigation.dart';
import 'package:owling/core/repository.dart';
import 'package:owling/core/route_generator.dart';

import '../design.dart';

class BottomNavigator extends StatelessWidget {
  final bool show;
  const BottomNavigator(this.show, {Key? key}) : super(key: key);

  Widget buildBottomBarButton(
    context,
    int index,
    String text,
    IconData iconData,
    Function()? onPress,
  ) {
    return Expanded(
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(3),
        child: GestureDetector(
          onTap: onPress,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Stack(
              children: [
                SizedBox(
                  //width: 60,
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconData,
                        size: 24,
                        color: navColorForLeftMenuItem(context, index),
                      ),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: navColorForLeftMenuItem(context, index),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomBar(context) {
    bool showHome = true;
    bool showCetus = true;
    /*bool showUnits = true;
    bool showCharts = true;
    bool showMaps = true;*/
    bool showMore = true;

    switch (navCurrentPath(context)) {
      case "/":
        showHome = false;
        /*showUnits = false;
        showCharts = false;
        showMaps = false;*/
        showMore = false;
        break;
    }

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          border: Border(
            top: BorderSide(color: DesignColors.fore2(), width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            showHome
                ? buildBottomBarButton(context, 0, "Home", Icons.apps, () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    "/home",
                    arguments: HomeFormArgument(
                      Repository().lastSelectedConnection,
                    ),
                  );
                })
                : Container(),
            showCetus
                ? buildBottomBarButton(context, 1, "Cetus", Icons.apps, () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context,
                    "/cetus",
                    arguments: CommonFormArgument(
                      Repository().lastSelectedConnection,
                    ),
                  );
                })
                : Container(),
            showMore
                ? buildBottomBarButton(
                  context,
                  4,
                  "More",
                  Icons.more_horiz,
                  () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pop();
                    Navigator.pushNamed(
                      context,
                      "/more",
                      arguments: MoreFormArgument(
                        Repository().lastSelectedConnection,
                      ),
                    );
                  },
                )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return Container();
    }
    return buildBottomBar(context);
  }
}
