import 'package:flutter/material.dart';
import 'package:owling/core/base/app.dart';
import 'package:owling/core/common/cetus.dart';
import 'package:owling/core/tools/short_address.dart';
import 'package:sui/sui.dart';

class OwnedObjectsWidget extends StatefulWidget {
  final String address;

  const OwnedObjectsWidget(this.address, {super.key});

  @override
  OwnedObjectsWidgetState createState() => OwnedObjectsWidgetState();
}

class OwnedObjectsWidgetState extends State<OwnedObjectsWidget> {
  @override
  void initState() {
    super.initState();

    loadOwnedObjects();
  }

  List<ObjectInfo> ownedObjects = [];

  bool loading = false;
  bool shownAll = false;

  void loadOwnedObjects() async {
    if (loading) {
      return;
    }

    setState(() {
      loading = true;
      shownAll = true;
    });

    String? nextCursor;
    bool firstIteration = true;
    SuiObjectDataOptions options = SuiObjectDataOptions();
    options.showType = true;
    options.showOwner = true;
    options.showDisplay = true;
    options.showContent = false;
    while (firstIteration || nextCursor != null) {
      firstIteration = false;
      var getOwnedObjectsResult = await App().client.getOwnedObjects(
        widget.address,
        cursor: nextCursor,
        limit: 50,
        options: options,
      );
      if (getOwnedObjectsResult.hasNextPage) {
        nextCursor = getOwnedObjectsResult.nextCursor;
      } else {
        nextCursor = null;
      }
      for (SuiObjectResponse obj in getOwnedObjectsResult.data) {
        ObjectInfo info = ObjectInfo();
        if (obj.data == null) {
          continue;
        }
        info.id = obj.data!.objectId;
        info.type = obj.data!.type ?? "";

        if (obj.data!.owner != null) {
          if (obj.data!.owner!.addressOwner != null) {
            info.owner = obj.data!.owner!.addressOwner!;
          }
          if (obj.data!.owner!.objectOwner != null) {
            info.owner = obj.data!.owner!.objectOwner!;
          }
        }

        if (info.type.contains("coin::Coin")) {
          var parts = info.type.split("::coin::Coin<");
          if (parts.length == 2) {
            info.coinType = parts[1].substring(0, parts[1].length - 1);
          }
        }

        if (info.coinType.isNotEmpty) {
          var coinInfo = await App().getCoinInfo(info.coinType);
          info.coinInfo = coinInfo;
        }

        ownedObjects.add(info);

        if (ownedObjects.length >= 50) {
          shownAll = false;
          break;
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {});
    }

    setState(() {
      loading = false;
    });
  }

  Widget buildOwnedObjects(BuildContext context) {
    List<Widget> widgets = [];
    for (ObjectInfo info in ownedObjects) {
      if (info.coinType.isNotEmpty) {
        widgets.add(
          Text(
            "${shortAddress(info.id)} ${info.coinInfo.name} (${info.coinInfo.symbol})",
            style: TextStyle(fontFamily: "RobotoMono"),
          ),
        );
      } else {
        widgets.add(
          Text(
            "${shortAddress(info.id)} ${info.type}",
            style: TextStyle(fontFamily: "RobotoMono"),
          ),
        );
      }
    }
    if (loading) {
      widgets.add(Text("Loading..."));
    }
    if (!shownAll) {
      widgets.add(Text("more..."));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Owned objects for ${shortAddress(widget.address)}"),
        buildOwnedObjects(context),
      ],
    );
  }
}
