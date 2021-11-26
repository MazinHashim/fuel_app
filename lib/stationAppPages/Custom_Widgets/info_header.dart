import 'package:flutter/material.dart';

class InfoHeader extends StatelessWidget {
  const InfoHeader({
    Key key,
    @required this.locale,
    @required this.name,
    this.margin
  }) : super(key: key);

  final Locale locale;
  final String name;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(top: 0.0),
      padding: EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 5.0,
                color: Colors.grey[400],
                offset: locale.languageCode.contains('ar')
                    ? Offset(-2.0, 5.0)
                    : Offset(2.0, 5.0))
          ],
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.horizontal(
            left: locale.languageCode.contains('ar')
                ? Radius.circular(50.0)
                : Radius.circular(0.0),
            right: locale.languageCode.contains('ar')
                ? Radius.circular(0.0)
                : Radius.circular(50.0),
          )),
      child: Text(
        name,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Josefin",
            fontSize: 17.0),
      ),
    );
  }
}