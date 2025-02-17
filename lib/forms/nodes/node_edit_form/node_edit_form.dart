import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:owling/core/route_generator.dart';
import 'package:owling/core/workspace/workspace.dart';
import 'package:owling/widgets/error_dialog/error_dialog.dart';
import 'package:owling/widgets/title_bar/title_bar.dart';

import '../../../core/design.dart';
import '../../../core/workspace/add_local_connection.dart';

class NodeEditForm extends StatefulWidget {
  final NodeEditFormArgument arg;
  const NodeEditForm({super.key, required this.arg});

  @override
  State<StatefulWidget> createState() {
    return NodeEditFormSt();
  }
}

class NodeEditFormSt extends State<NodeEditForm> {
  bool firstAccountLoaded = false;

  final TextEditingController _txtControllerName = TextEditingController();
  final TextEditingController _txtControllerAddress = TextEditingController();


  String connectionError = "";

  @override
  void initState() {
    super.initState();

    _txtControllerName.text = widget.arg.connection.name;
    _txtControllerAddress.text = widget.arg.connection.address;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void tryToEditNode(String name, String address) {
    editNode(widget.arg.connection.id, name, address)
        .then((conn) {
          if (conn != null) {
            Navigator.pop(context, conn);
            return;
          }
          showErrorDialog(context, "Error");
        })
        .catchError((err) {
          showErrorDialog(context, "$err");
        });
  }

  Widget buildAddNodeButton() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 130,
          height: 36,
          child: ElevatedButton(
            onPressed: () {
              tryToEditNode(
                _txtControllerName.text,
                _txtControllerAddress.text,
              );
            },
            child: const Text("Save"),
          ),
        ),
      ),
    );
  }

  Widget buildScanButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              usingScanner = true;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: DesignColors.fore()),
            ),
            padding: const EdgeInsets.all(20),
            child: Icon(Icons.qr_code, size: 72, color: DesignColors.fore()),
          ),
        ),
      ],
    );
  }

  int mode = 0;

  Widget buildMode0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          autofocus: true,
          controller: _txtControllerName,
          decoration: const InputDecoration(labelText: "Name"),
        ),
        TextField(
          autofocus: true,
          controller: _txtControllerAddress,
          decoration: const InputDecoration(labelText: "Address"),
        ),
        buildAddNodeButton(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buildAddDemo()],
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.only(top: 30),
            child: const Text("Scan QR Code"),
          ),
        ),
        buildScanButton(),
      ],
    );
  }

  Widget buildMode1() {
    return Column(
      children: [
        TextField(
          autofocus: true,
          controller: _txtControllerAddress,
          decoration: const InputDecoration(labelText: "Access Data"),
        ),
        MobileScanner(
          // fit: BoxFit.contain,
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            //final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
            }
          },
        ),
      ],
    );
  }

  Widget buildMode() {
    if (mode == 0) {
      return buildMode0();
    }
    if (mode == 1) {
      return buildMode1();
    }
    return buildMode0();
  }

  Widget buildAddDemo() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: OutlinedButton(
        onPressed: () {},
        child: const Text("Load Demo Node"),
      ),
    );
  }

  Widget buildContent() {
    return Expanded(
      child: Container(padding: const EdgeInsets.all(10), child: buildMode()),
    );
  }

  MobileScannerController cameraController = MobileScannerController();

  final ValueNotifier<double> _height2 = ValueNotifier<double>(100);
  final ValueNotifier<double> _height3 = ValueNotifier<double>(200);

  Widget buildQRCodeScanner(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(
        Connection.makeDefault(),
        "Connect To Node",
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: _height3,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
                return const Icon(Icons.flash_off, color: Colors.grey);
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: _height2,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }

                return const Icon(Icons.camera_rear);
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          //final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            //debugPrint('Barcode found! ${barcode.rawValue}');
            if (barcode.rawValue != null) {
              setState(() {
                _txtControllerAddress.text = barcode.rawValue!;
                usingScanner = false;
              });
            }
          }
        },
      ),
    );
  }

  bool usingScanner = false;

  @override
  Widget build(BuildContext context) {
    if (usingScanner) {
      return buildQRCodeScanner(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        String version = "";

        return Scaffold(
          appBar: TitleBar(null, "Add Address", version: version),
          body: Container(
            color: DesignColors.mainBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [buildContent()],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
