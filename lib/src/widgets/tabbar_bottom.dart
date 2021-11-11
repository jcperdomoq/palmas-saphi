import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:las_palmas/src/pages/configuration/configuration_page.dart';
import 'package:las_palmas/src/pages/home/home_page.dart';
import 'package:las_palmas/src/pages/plot/plots_page.dart';
import 'package:las_palmas/src/pages/synchronization/synchronization_page.dart';
import 'package:las_palmas/src/providers/plants_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class TabbarBottom extends StatefulWidget {
  const TabbarBottom({Key? key}) : super(key: key);

  @override
  State<TabbarBottom> createState() => _TabbarBottomState();
}

class _TabbarBottomState extends State<TabbarBottom> {
  final _tabController = PersistentTabController(initialIndex: 0);
  int _currentIndex = 0;

  final List<Widget> _pageList = [
    HomePage(),
    PlotsPage(showFilter: true, editable: false),
    const SynchronizationPage(),
    const ConfigurationPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  _onItemTapped(index) {
    // _pageController.jumpToPage(index);
    _tabController.jumpToTab(index);
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Provider.of<PlantsProvider>(context, listen: false).refreshReports();
    }
  }

  BottomNavigationBarItem itemTab(label, pathIcon, index) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        pathIcon,
        color: _currentIndex == index ? const Color(0xFF00C347) : null,
      ),
    );
  }

  PersistentBottomNavBarItem navBarItem(label, pathIcon, index) {
    return PersistentBottomNavBarItem(
      activeColorPrimary: const Color(0xFF00C347),
      inactiveColorPrimary: const Color(0xFF828282),
      onPressed: (_) => _onItemTapped(index),
      icon: Column(
        children: [
          SvgPicture.asset(
            pathIcon,
            color: _currentIndex == index ? const Color(0xFF00C347) : null,
            height: 22,
            width: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: _currentIndex == index
                  ? const Color(0xFF00C347)
                  : const Color(0xFF828282),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        screens: _pageList,
        // stateManagement: false,
        navBarStyle: NavBarStyle.simple,
        controller: _tabController,
        backgroundColor: Colors.transparent,
        bottomScreenMargin: 0,
        navBarHeight: MediaQuery.of(context).viewPadding.bottom > 0 ? 80 : 60,
        confineInSafeArea: false,
        items: [
          navBarItem('Inicio', 'assets/images/home.svg', 0),
          navBarItem('Reportes', 'assets/images/reports.svg', 1),
          navBarItem('Sincronización', 'assets/images/synchronization.svg', 2),
          navBarItem('Configuración', 'assets/images/reports.svg', 3),
        ],
      ),
    );
  }
}
