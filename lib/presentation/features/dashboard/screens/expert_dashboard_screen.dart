import 'package:earnwise_app/presentation/features/conversations/screens/conversations_screen.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/expert_conversations_screen.dart';
import 'package:earnwise_app/presentation/features/explore/screens/explore_screen.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_home_screen.dart';
import 'package:earnwise_app/presentation/features/home/screens/home_screen.dart';
import 'package:earnwise_app/presentation/features/profile/screens/expert_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpertDashboardScreen extends StatefulWidget {
  const ExpertDashboardScreen({super.key});

  @override
  State<ExpertDashboardScreen> createState() => _ExpertDashboardScreenState();
}

class _ExpertDashboardScreenState extends State<ExpertDashboardScreen> {

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
          ExpertHomeScreen(),
          ExpertConversationsScreen(),
          Container(),
          ExpertSettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.message),
            label: 'Connects',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.peopleGroup),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}