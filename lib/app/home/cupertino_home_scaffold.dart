import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trywidgests/app/home/jobs/jobs_page.dart';
import 'package:trywidgests/app/home/tab_item.dart';

class CupertionHomeScaffold extends StatelessWidget {
  const CupertionHomeScaffold(
      {Key? key,
      required this.currentTab,
      required this.onSelectTab,
      required this.widgetBuilders,
        required this.navigationkeys,
      })
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem,GlobalKey<NavigatorState>> navigationkeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.account),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigationkeys[item],
          builder: (context) => widgetBuilders[item]!(context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemdata = TabItemData.alltabs[tabItem];
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(itemdata!.icon, color: color),
      label: itemdata.title == null ? '' : itemdata.title,
    );
  }
}
