import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';

class NavigationAppBar extends StatefulWidget {
  final TabController tbCont;

  const NavigationAppBar({Key key, @required this.tbCont}) : super(key: key);

  @override
  _NavigationAppBarState createState() => _NavigationAppBarState();
}

class _NavigationAppBarState extends State<NavigationAppBar> {
  int active = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations lng = AppLocalizations.of(context);

    Widget labeledTabs(String title, IconData icon, int index) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon,
              color: active == index
                  ? Theme.of(context).primaryColor
                  : Colors.black,
              size: 30.0),
          Text(
            title,
            style: TextStyle(
                color: active == index
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontFamily: "Josefin",
                fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.grey[200],
      title: TabBar(
        controller: widget.tbCont,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 2.2,
        onTap: (val) {
          setState(() {
            active = val;
          });
        },
        tabs: <Widget>[
          labeledTabs(lng.nearTab, Icons.local_gas_station, 0),
          labeledTabs(lng.companyTab, Icons.business, 1),
          labeledTabs(lng.favTab, Icons.favorite_border, 2),
        ],
      ),
    );
  }
}
