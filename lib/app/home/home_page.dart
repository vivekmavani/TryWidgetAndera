import 'package:flutter/material.dart';
import 'package:trywidgests/app/home/account/account_page.dart';
import 'package:trywidgests/app/home/cupertino_home_scaffold.dart';
import 'package:trywidgests/app/home/entries/entries_page.dart';
import 'package:trywidgests/app/home/jobs/jobs_page.dart';
import 'package:trywidgests/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs; 

  final Map<TabItem,GlobalKey<NavigatorState>> navigationkeys = {
    TabItem.jobs : GlobalKey<NavigatorState>(),
    TabItem.entries : GlobalKey<NavigatorState>(),
    TabItem.account : GlobalKey<NavigatorState>(),
  };

  Map<TabItem,WidgetBuilder> get widgetBuilders{
    return {
      TabItem.jobs :(_) => JobsPage(),
      TabItem.entries :(_) => EntriesPage.create(context),
      TabItem.account :(_) => AccountPage(),
    };
  }
  void _select(TabItem tabItem) {
    setState(() {
      if(tabItem == _currentTab)
        {
          // pop to first route
          navigationkeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
        }else{
        _currentTab=tabItem;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // WillPopScope control back button on android, using with global keys to control each navigation stack.
    return WillPopScope(
      onWillPop: () async => !await navigationkeys[_currentTab]!.currentState!.maybePop(),
      child: CupertionHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigationkeys: navigationkeys,
      ),
    );
  }


}
