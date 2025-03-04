import 'package:flutter/material.dart';
import 'package:owling/core/design.dart';
import 'package:owling/core/navigation.dart';
import 'package:owling/core/navigation/bottom_navigator.dart';
import 'package:owling/core/navigation/left_navigator.dart';
import 'package:owling/core/route_generator.dart';
import 'package:owling/widgets/title_bar/title_bar.dart';

class AboutForm extends StatefulWidget {
  final AboutFormArgument arg;
  const AboutForm(this.arg, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AboutFormSt();
  }
}

class AboutFormSt extends State<AboutForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool narrow = constraints.maxWidth < constraints.maxHeight;
        bool showLeft = !narrow;
        bool showBottom = narrow;

        String version = "2.0.1";

        return Scaffold(
          appBar: TitleBar(
            widget.arg.connection,
            "About",
            actions: <Widget>[buildHomeButton(context)],
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
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: const Image(
                                image: AssetImage(
                                  'assets/images/ios/Icon-App-40x40@1x.png',
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                "OWLING",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "v $version",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "Copyright (c) Poluianov Ivan, 2023-${DateTime.now().year}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: const Text(
                                  'OWLING.U00.IO',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    //decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              onTap: () {
                                //var url = Uri.parse("https://gazer.cloud/");
                                //launchUrl(url);
                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: const Text(
                                  'GitHub',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    //decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              onTap: () {
                                /*var url = Uri.parse(
                                      "https://github.com/ipoluianov/gazer_client");*/
                                //launchUrl(url);
                              },
                            ),
                          ],
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
}
