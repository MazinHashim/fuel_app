import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Locale locale;
  final EdgeInsetsGeometry margin;
  const AppCard({Key key, @required this.child, @required this.locale, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 0.5),
            borderRadius: BorderRadius.circular(7.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(18, 35, 100, 1.0).withOpacity(0.2),
                  blurRadius: 15.0,
                  offset: locale.languageCode.contains('ar')
                      ? Offset(-8.0, 10.0)
                      : Offset(8.0, 10.0))
            ]),
        margin: margin ?? EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
        child: child);
  }
}
