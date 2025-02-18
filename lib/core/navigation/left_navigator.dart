import 'package:flutter/material.dart';
import 'package:owling/core/navigation.dart';
import 'package:owling/core/navigation/left_navigator_button.dart';
import 'package:owling/core/repository.dart';
import 'package:owling/core/route_generator.dart';
import 'package:owling/widgets/borders/border_09_left_navigator_main.dart';

class LeftNavigator extends StatelessWidget {
  final bool show;
  const LeftNavigator(this.show, {Key? key}) : super(key: key);

  Widget buildLeftBarButton(
    context,
    int index,
    String text,
    IconData iconData,
    Function()? onPress,
  ) {
    return LeftNavigatorButton(
      index,
      text,
      iconData,
      onPress,
      navColorForLeftMenuItem(context, index),
      navIsCurrentForLeftMenuItem(context, index),
    );
  }

  Widget buildLeftBar(context) {
    bool showHome = true;
    bool showCetus = true;
    /*bool showUnits = true;
    bool showCharts = true;
    bool showMaps = true;*/
    bool showMore = true;

    switch (navCurrentPath(context)) {
      case "/":
        showHome = false;
        showCetus = false;
        /*showUnits = false;
        showCharts = false;
        showMaps = false;*/
        showMore = false;
        break;
    }

    return Container(
      width: 120,
      decoration: const BoxDecoration(
        //color: Colors.black12,
      ),
      child: Stack(
        children: [
          Border09Painter.build(false),
          Container(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                showHome
                    ? buildLeftBarButton(context, 0, "Home", Icons.apps, () {
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
                    ? buildLeftBarButton(context, 1, "Cetus", Icons.apps, () {
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
                    ? buildLeftBarButton(
                      context,
                      4,
                      "More",
                      Icons.more_horiz,
                      () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return buildLeftBar(context);
      },
    );
  }
}
