import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Owned objects"),
        Text(widget.address),
      ],
    );
  }
}
