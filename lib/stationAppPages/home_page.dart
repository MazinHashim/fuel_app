import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './station_view.dart';
import './logo_app_bar.dart';
import './navigation_app_bar.dart';
import './company_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final formKey = new GlobalKey<FormState>();
  ScrollController _scrollController;
  TabController _tabController;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  
  User user;
  bool isLoadUser = false;
  Future<Null> getLoggedUser() async {
    SharedPreferences pref = await _sPref;
    List userInfo = pref.getStringList("user_token");
    setState(() {
      user = new User(
        userId: int.parse(userInfo.elementAt(0)),
        username: userInfo.elementAt(1),
        password: userInfo.elementAt(2),
        email: userInfo.elementAt(3),
        inQ: userInfo.elementAt(4)=="true"?true:false,
        verified: userInfo.elementAt(5)=="true"?true:false);
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _tabController = new TabController(length: 3, vsync: this);
    getLoggedUser();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final AppLocalizations lng = AppLocalizations.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            new LogoAppBar(),
            new NavigationAppBar(tbCont: _tabController),
            SliverFillRemaining(
              child: user==null?Center(child:Text(lng.loadingtxt)):TabBarView(
                controller: _tabController,
                children: <Widget>[
                  new StationView(scfKey:scaffoldKey, tbCont: _tabController,user: user),
                  new CompanyView(user: user),
                  new StationView(scfKey:scaffoldKey, tbCont: _tabController,user: user)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
