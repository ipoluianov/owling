import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owling/core/tools/short_address.dart';
import 'package:owling/core/tools/snack.dart';

class AddressWidget extends StatefulWidget {
  final String address;

  const AddressWidget(this.address, {super.key});

  @override
  State<StatefulWidget> createState() {
    return AddressWidgetState();
  }
}

// icon hover color

class AddressWidgetState extends State<AddressWidget> {

  Color iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(shortAddress(widget.address),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        IconButton(
          onHover: (value) {
            if (value) {
              setState(() {
                iconColor = Colors.green;
              });
            } else {
              setState(() {
                iconColor = Colors.white;
              });
            }
          },
          onPressed: () {
            Clipboard.setData(ClipboardData(text: widget.address));
            showSnackMessage(context, "Address copied to clipboard");
          },
          icon: Icon(Icons.copy, color: iconColor),

        ),
      ],
    );
  }
}
