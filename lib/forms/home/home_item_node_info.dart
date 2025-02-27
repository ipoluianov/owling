import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owling/core/base/app.dart';
import 'package:owling/core/base/get_balance.dart';
import 'package:owling/core/common/cetus.dart';
import 'package:owling/core/design.dart';
import 'package:owling/widgets/address_widget.dart';
import 'package:owling/widgets/owned_objects_widget/owned_objects_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/tools/place_holders.dart';
import 'home_item.dart';

class HomeItemNodeInfo extends HomeItem {
  HomeItemNodeInfo(
    super.arg,
    super.config,
    super.onEdit,
    super.onRemove,
    super.onUp,
    super.onDown, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return HomeItemNodeInfoState();
  }
}

class HomeItemNodeInfoState extends State<HomeItemNodeInfo> {
  late Timer timerUpdate_;

  @override
  void initState() {
    super.initState();
    load();
    loadCommonInfo();
    timerUpdate_ = Timer.periodic(const Duration(seconds: 1), (timer) {
      load();
    });
  }

  @override
  void dispose() {
    timerUpdate_.cancel();
    super.dispose();
  }

  bool loading = false;
  bool loaded = false;

  String loadingError = "";
  String nodeName = "";

  void load() {}

  void loadCommonInfo() async {
    try {
      var bal = await getSuiBalance(
        App().client,
        widget.arg.connection.address,
        coinTypeSUI,
      );
      {
        var b = await bal.amountString();
        setState(() {
          accountBalance = bal;
          balance = b;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loadingError = "$e";
          loading = false;
        });
      }
    }
  }

  Widget buildCommonInfoContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Balance: $balance",
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: DesignColors.fore(),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  AccountBalance accountBalance = AccountBalance();
  String balance = "";

  Widget buildCommonInfo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.buildH1(context, "COMMON INFO", false, false, false),
          loading ? loadingPlaceHolder() : buildCommonInfoContent(),
        ],
      ),
    );
  }

  Widget loadingPlaceHolder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade500,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1000),
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: const [
            ContentPlaceholder(lineType: ContentLineType.threeLines),
          ],
        ),
      ),
    );
  }

  Widget buildUnit(String unitName, String itemName, String value, String uom) {
    return Container(
      //color: DesignColors.back2(),
      margin: const EdgeInsets.only(left: 0, top: 0, bottom: 12, right: 6),
      constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(width: 3, color: Colors.green)),
      ),
      padding: const EdgeInsets.only(left: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            unitName,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: DesignColors.fore(),
              fontSize: 16,
            ),
          ),
          Text(
            "$itemName = $value $uom",
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.green,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade400,
      period: const Duration(milliseconds: 1000),
      enabled: true,
      child: buildUnit("Unit Name", "Item Name", "Value", "UOM"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.buildH1(
            context,
            widget.arg.connection.name,
            true,
            false,
            true,
          ),
          AddressWidget(widget.arg.connection.address),
          buildCommonInfo(context),
          OwnedObjectsWidget(widget.arg.connection.address),
        ],
      ),
    );
  }
}
