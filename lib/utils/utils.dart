import 'package:flutter/cupertino.dart';

void hideKeyBoard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String camelCase(String string) {
  final list = string.split(" ");
  StringBuffer resultBuffer = StringBuffer();
  for (String element in list) {
    if (element.isNotEmpty) {
      element = element.substring(0, 1).toUpperCase() +
          element.substring(1, element.length);
      resultBuffer.write(element);
      resultBuffer.write(" ");
    }
  }
  return resultBuffer.toString().trim();
}

Future<T> showMyDialog<T>({
  @required BuildContext context,
  @required Widget child,
  Color backColor = const Color(0xccFFFFFF),
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: backColor,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Builder(builder: (context) => child);
    },
    transitionBuilder: _buildCupertinoDialogTransitions,
  );
}

Widget _buildCupertinoDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  final CurvedAnimation fadeAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeInOut,
  );
  if (animation.status == AnimationStatus.reverse) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
  return FadeTransition(
    opacity: fadeAnimation,
    child: ScaleTransition(
      child: child,
      scale: animation.drive(_dialogScaleTween),
    ),
  );
}

final Animatable<double> _dialogScaleTween = Tween<double>(begin: 1.3, end: 1.0)
    .chain(CurveTween(curve: Curves.linearToEaseOut));
