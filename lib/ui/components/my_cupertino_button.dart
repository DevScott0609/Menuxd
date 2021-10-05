import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/color_palette.dart';

class MyCupertinoButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  MyCupertinoButton({this.child, Key key, this.onPressed}) : super(key: key);

  _MyCupertinoButtonState createState() => _MyCupertinoButtonState();
}

class _MyCupertinoButtonState extends State<MyCupertinoButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          pressed = false;
        });
      },
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 50),
        margin: EdgeInsets.symmetric(
            horizontal: pressed ? 20 : 0, vertical: pressed ? 20 : 0),
        child: CupertinoButton(
          pressedOpacity: 1,
          borderRadius: BorderRadius.circular(50),
          padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: pressed ? 0 : 15),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: widget.child,
          ),
          onPressed: widget.onPressed,
          color: ColorPalette.melon,
        ),
      ),
    );
  }
}
