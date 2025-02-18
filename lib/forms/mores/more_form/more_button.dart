import 'package:flutter/material.dart';
import 'package:owling/core/design.dart';
import 'package:owling/widgets/borders/border_01_item.dart';

class MoreButton extends StatefulWidget {
  final Function() onClicked;
  final String name;
  final Icon img;
  final int index;
  const MoreButton(this.onClicked, this.name, this.img, this.index, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MoreButtonState();
  }
}

class MoreButtonState extends State<MoreButton> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return buildUnit();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  void gotoUnit() {
    widget.onClicked();
  }

  late final AnimationController _controller = AnimationController(
    vsync: this,
  )..animateTo(1,
      duration: Duration(
        milliseconds: 200 + widget.index * 40,
      ),
      curve: Curves.linear);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  bool hover = false;

  Widget buildUnit() {
    return ScaleTransition(
      scale: _animation,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            hover = true;
          });
        },
        onExit: (_) {
          setState(() {
            hover = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            gotoUnit();
          },
          child: Container(
            // color: Colors.black26,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: 200,
              height: 150,
              child: Stack(
                children: [
                  Border01Painter.build(hover),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              DesignColors.fore(), BlendMode.srcATop),
                          child: widget.img,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(left: 0, top: 6),
                          child: Text(
                            widget.name,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: DesignColors.fore()),
                          ),
                        ),
                      ),
                      Card(
                          color: Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
