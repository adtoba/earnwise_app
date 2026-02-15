import 'package:earnwise_app/presentation/features/conversations/screens/conversations_screen.dart';
import 'package:earnwise_app/presentation/features/explore/screens/explore_screen.dart';
import 'package:earnwise_app/presentation/features/home/screens/home_screen.dart';
import 'package:earnwise_app/presentation/features/settings/screens/settings_screen.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final PageController _pageController = PageController();

  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: _onPageChanged,
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          ExploreScreen(),
          ConversationsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyles.mediumRegular,
        unselectedLabelStyle: TextStyles.mediumRegular,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house, size: 20,),
            tooltip: "Home",
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.compass, size: 20,),
            tooltip: "Explore",
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.message, size: 20,),
            tooltip: "Connects",
            label: 'Connects',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.gear, size: 20,),
            tooltip: "Settings",
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}