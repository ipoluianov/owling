import 'package:flutter/material.dart';
import 'package:owling/core/design.dart';
import 'package:owling/core/repository.dart';
import 'package:owling/widgets/action_button/action_button.dart';

import 'route_generator.dart';

Color navColorForLeftMenuItem(context, int index) {
  if (index == navCurrentIndex(context)) {
    return DesignColors.accent();
  }
  return DesignColors.fore();
}

Color navBackcolorForLeftMenuItem(context, int index) {
  if (index == navCurrentIndex(context)) {
    return Colors.black26;
  }
  return Colors.transparent;
}

bool navIsCurrentForLeftMenuItem(context, int index) {
  if (index == navCurrentIndex(context)) {
    return true;
  }
  return false;
}

int navCurrentIndex(context) {
  switch (Repository().navIndex) {
    case NavIndex.home:
      return 0;
    case NavIndex.cetus:
      return 1;
    case NavIndex.more:
      return 4;
  }
}

String navCurrentPath(context) {
  var path = Repository().lastPath;
  var r = ModalRoute.of(context);
  if (r != null) {
    if (r.settings.name != null) {
      path = r.settings.name!;
    }
  }
  return path;
}

Widget buildActionButton(
  context,
  IconData? icon,
  String tooltip,
  Function() onPress, {
  key,
}) {
  return buildActionButtonFull(
    context,
    icon,
    tooltip,
    onPress,
    false,
    key: key,
  );
}

Widget buildActionButtonFull(
  context,
  IconData? icon,
  String tooltip,
  Function() onPress,
  bool checked, {
  Color? imageColor,
  Color? backColor,
  key,
}) {
  return ActionButton(
    icon: icon,
    tooltip: tooltip,
    onPress: onPress,
    checked: checked,
    imageColor: imageColor,
    backColor: backColor,
    key: key,
  );
}

Widget buildHomeButton(context) {
  return Container(
    padding: const EdgeInsets.only(left: 5),
    child: buildActionButton(context, Icons.home_outlined, "List of Nodes", () {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.popAndPushNamed(context, "/", arguments: MainFormArgument());
    }),
  );
}
