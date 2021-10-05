import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final Color color;
  final double opacity; 

  MyDialog(
      {this.child,
      this.width,
      this.height,
      this.borderRadius = 20,
      this.color = Colors.white,
      this.opacity = 0.8, });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: Offset(0, 21),
                blurRadius: 21,
                color: Colors.black.withOpacity(0.1))
          ], borderRadius: BorderRadius.circular(borderRadius)),
          child: Card(
           child: child,
            elevation: 0,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
          ),
        ),
      ),
    );
  }
}
